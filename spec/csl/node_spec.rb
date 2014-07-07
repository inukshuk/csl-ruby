require 'spec_helper'

module CSL

	describe Node do

    it { is_expected.not_to be nil }
    it { is_expected.not_to have_children }
    it { is_expected.not_to have_attributes }

		describe 'given a FooBarNode with attributes :foo and :bar and a TestNode without defined attributes' do
      before(:all) do
        class FooBarNode < Node
          attr_struct :foo, :bar
        end
        class TestNode < Node
        end
      end

      it 'creates FooBarNode::Attributes' do
        expect(FooBarNode.const_defined?(:Attributes)).to be_truthy
      end

      it 'does not create TestNode::Attributes' do
        expect(TestNode.const_defined?(:Attributes)).not_to be_truthy
      end

		  it 'TestNode attributes are a regular Hash' do
		    expect(TestNode.new.attributes).to be_a(Hash)
		  end

		  it 'FooBarNode attributes are a Struct' do
		    expect(FooBarNode.new.attributes).to be_a(Struct)
		  end

		  describe '#match?' do
		    it 'matches an empty query' do
		      expect(FooBarNode.new.match?({})).to be_truthy
		      expect(FooBarNode.new(:foo => 'Foo').match?({})).to be_truthy
		      expect(TestNode.new.match?({})).to be_truthy
		      expect(TestNode.new(:foo => 'Foo').match?({})).to be_truthy
		    end

        it 'returns true for a matching query' do
		      expect(FooBarNode.new(:foo => 'bar').match?(:foo => 'bar')).to be_truthy
		      expect(FooBarNode.new(:bar => 'b', :foo => 'f').match?(:foo => 'f', :bar => 'b')).to be_truthy
        end

        it 'returns false for non-matching query' do
		      expect(FooBarNode.new.match?(:foo => 'bar')).to be_falsey
		      expect(FooBarNode.new(:foo => 'f').match?(:foo => 'f', :bar => 'b')).to be_falsey
        end

        it 'returns false if the query contains unknown attributes' do
		      expect(FooBarNode.new(:foo => 'f').match?(:foo => 'f', :unknown => 'u')).to be_falsey
        end

        it 'matches irrespective of order' do
		      expect(FooBarNode.new(:bar => 'b', :foo => 'f').match?(:foo => 'f', :bar => 'b')).to be_truthy
		      expect(FooBarNode.new(:foo => 'f', :bar => 'b').match?(:foo => 'f', :bar => 'b')).to be_truthy
		      expect(FooBarNode.new(:foo => 'f', :bar => 'b').match?(:bar => 'b', :foo => 'f')).to be_truthy
		      expect(FooBarNode.new(:bar => 'b', :foo => 'f').match?(:bar => 'b', :foo => 'f')).to be_truthy
        end

		    it 'matches an empty query with the correct node name' do
		      expect(FooBarNode.new.match?('foo-bar-node', {})).to be_truthy
		      expect(FooBarNode.new(:foo => 'Foo').match?('foo-bar-node', {})).to be_truthy
		      expect(TestNode.new.match?('test-node', {})).to be_truthy
		      expect(TestNode.new(:foo => 'Foo').match?('test-node', {})).to be_truthy
		    end

		    it 'does not match other node names' do
		      expect(FooBarNode.new.match?(:name, {})).not_to be_truthy
		      expect(FooBarNode.new(:foo => 'Foo').match?(:name, {})).not_to be_truthy
		      expect(TestNode.new.match?(:name, {})).not_to be_truthy
		      expect(TestNode.new(:foo => 'Foo').match?(:name, {})).not_to be_truthy
		    end
		  end

		  describe '#attributes_for' do
		    it 'returns an empty hash when there no attributes are set' do
		      expect(TestNode.new.attributes_for).to be_empty
		      expect(TestNode.new.attributes_for(:x, :y)).to be_empty

		      expect(FooBarNode.new.attributes_for).to be_empty
		      expect(FooBarNode.new.attributes_for(:x, :y)).to be_empty
		      expect(FooBarNode.new.attributes_for(:foo, :bar)).to be_empty
		    end

		    it 'returns an empty hash when no attributes match the filter' do
		      expect(TestNode.new(:foo => 'foo').attributes_for).to be_empty
		      expect(TestNode.new(:foo => 'foo').attributes_for(:x, :y)).to be_empty

		      expect(FooBarNode.new(:foo => 'foo').attributes_for).to be_empty
		      expect(FooBarNode.new(:foo => 'foo').attributes_for(:x, :y)).to be_empty
		    end

		    it 'returns a hash of all set attributes that match the filter' do
		      expect(TestNode.new(:foo => 'foo', :bar => 'bar').attributes_for(:x, :foo)).to eq({ :foo => 'foo' })
		      expect(FooBarNode.new(:foo => 'foo', :bar => 'bar').attributes_for(:x, :foo)).to eq({ :foo => 'foo' })
		    end
		  end

		  describe '#formatting_options' do
		    it 'returns an empty hash by default' do
		      expect(TestNode.new.formatting_options).to be_empty
		      expect(FooBarNode.new.formatting_options).to be_empty
		    end

		    it 'returns an empty hash if there are no formatting attributes' do
		      expect(TestNode.new(:foo => 'foo', :bar => 'bar').formatting_options).to be_empty
		      expect(FooBarNode.new(:foo => 'foo', :bar => 'bar').formatting_options).to be_empty
		    end

		    it "returns a hash of the node's formatting attributes" do
		      expect(TestNode.new(:foo => 'foo', :'font-style' => 'italic').formatting_options).to eq({ :'font-style' => 'italic' })
		    end
		  end

  		describe '#values_at' do
  		  it 'FooBarNode accepts attribute names' do
  		    expect(FooBarNode.new(:foo => 'Foo', :bar => 'Bar').values_at(:bar, :foo)).to eq(%w{ Bar Foo })
  		    expect(FooBarNode.new(:foo => 'Foo').values_at(:bar, :foo)).to eq([nil, 'Foo'])
  		    expect(FooBarNode.new(:foo => 'Foo').values_at(:unknown, :foo)).to eq([nil, 'Foo'])
  		  end

  		  it 'TestNode accepts attribute names' do
  		    expect(TestNode.new(:foo => 'Foo', :bar => 'Bar').values_at(:bar, :foo)).to eq(%w{ Bar Foo })
  		    expect(TestNode.new(:foo => 'Foo').values_at(:bar, :foo)).to eq([nil, 'Foo'])
  		    expect(TestNode.new(:foo => 'Foo').values_at(:unknown, :foo)).to eq([nil, 'Foo'])
  		  end
      end

      describe '#to_a' do
        it 'returns an empty list by default' do
          expect(Node.new.attributes.to_a).to eq([])
        end

        it 'TestNode returns an empty list by default' do
          expect(TestNode.new.attributes.to_a).to eq([])
        end

        # it 'TestNode returns a list of all key/value pairs' do
        #   TestNode.new(:foo => 'Foo', :bar => 'Bar').attributes.to_a.map(&:last).sort.should == %w{ Bar Foo }
        # end

        # it 'FooBarNode returns an empty list by default' do
        #   FooBarNode.new.attributes.to_a.should == []
        # end

        # it 'FooBarNode returns a list of all key/value pairs' do
        #   FooBarNode.new(:foo => 'Foo', :bar => 'Bar').attributes.to_a.map(&:last).sort.should == %w{ Bar Foo }
        # end
      end

      describe 'attributes.keys' do
        it 'returns all attribute names as symbols' do
          expect(TestNode.new.attributes.keys).to be_empty
          expect(FooBarNode.new.attributes.keys).to eq([:foo, :bar])
        end
      end
    end
	end

  describe TextNode do

    it { is_expected.not_to be nil }
    it { is_expected.not_to have_children }
    it { is_expected.not_to have_attributes }

    describe '.new' do
      it 'accepts a hash of attributes' do
        expect(TextNode.new(:foo => 'bar')).to have_attributes
      end

      it 'yields itself to the optional block' do
        expect(TextNode.new { |n| n.text = 'foo' }.text).to eq('foo')
      end

      it 'accepts hash and yields itself to the optional block' do
        expect(TextNode.new(:foo => 'bar') { |n| n.text = 'foo' }.to_xml).to eq('<text-node foo="bar">foo</text-node>')
      end
    end

    describe '#pretty_print' do
      it 'prints the text node as XML' do
        expect(TextNode.new(:foo => 'bar') { |n| n.text = 'foo' }.pretty_print).to eq('<text-node foo="bar">foo</text-node>')
      end
    end
  end

end
