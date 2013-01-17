require 'spec_helper'

module CSL

	describe Node do

    it { should_not be nil }
    it { should_not have_children }
    it { should_not have_attributes }

		describe 'given a FooBarNode with attributes :foo and :bar and a TestNode without defined attributes' do
      before(:all) do
        class FooBarNode < Node
          attr_struct :foo, :bar
        end
        class TestNode < Node
        end
      end

      it 'creates FooBarNode::Attributes' do
        FooBarNode.const_defined?(:Attributes).should be_true
      end

      it 'does not create TestNode::Attributes' do
        TestNode.const_defined?(:Attributes).should_not be_true
      end

		  it 'TestNode attributes are a regular Hash' do
		    TestNode.new.attributes.should be_a(Hash)
		  end

		  it 'FooBarNode attributes are a Struct' do
		    FooBarNode.new.attributes.should be_a(Struct)
		  end

		  describe '#match?' do
		    it 'matches an empty query' do
		      FooBarNode.new.match?({}).should be_true
		      FooBarNode.new(:foo => 'Foo').match?({}).should be_true
		      TestNode.new.match?({}).should be_true
		      TestNode.new(:foo => 'Foo').match?({}).should be_true
		    end

        it 'returns true for a matching query' do
		      FooBarNode.new(:foo => 'bar').match?(:foo => 'bar').should be_true
		      FooBarNode.new(:bar => 'b', :foo => 'f').match?(:foo => 'f', :bar => 'b').should be_true
        end

        it 'returns false for non-matching query' do
		      FooBarNode.new.match?(:foo => 'bar').should be_false
		      FooBarNode.new(:foo => 'f').match?(:foo => 'f', :bar => 'b').should be_false
        end

        it 'returns false if the query contains unknown attributes' do
		      FooBarNode.new(:foo => 'f').match?(:foo => 'f', :unknown => 'u').should be_false
        end

        it 'matches irrespective of order' do
		      FooBarNode.new(:bar => 'b', :foo => 'f').match?(:foo => 'f', :bar => 'b').should be_true
		      FooBarNode.new(:foo => 'f', :bar => 'b').match?(:foo => 'f', :bar => 'b').should be_true
		      FooBarNode.new(:foo => 'f', :bar => 'b').match?(:bar => 'b', :foo => 'f').should be_true
		      FooBarNode.new(:bar => 'b', :foo => 'f').match?(:bar => 'b', :foo => 'f').should be_true
        end

		    it 'matches an empty query with the correct node name' do
		      FooBarNode.new.match?('foo-bar-node', {}).should be_true
		      FooBarNode.new(:foo => 'Foo').match?('foo-bar-node', {}).should be_true
		      TestNode.new.match?('test-node', {}).should be_true
		      TestNode.new(:foo => 'Foo').match?('test-node', {}).should be_true
		    end

		    it 'does not match other node names' do
		      FooBarNode.new.match?(:name, {}).should_not be_true
		      FooBarNode.new(:foo => 'Foo').match?(:name, {}).should_not be_true
		      TestNode.new.match?(:name, {}).should_not be_true
		      TestNode.new(:foo => 'Foo').match?(:name, {}).should_not be_true
		    end
		  end

		  describe '#attributes_for' do
		    it 'returns an empty hash when there no attributes are set' do
		      TestNode.new.attributes_for.should be_empty
		      TestNode.new.attributes_for(:x, :y).should be_empty

		      FooBarNode.new.attributes_for.should be_empty
		      FooBarNode.new.attributes_for(:x, :y).should be_empty
		      FooBarNode.new.attributes_for(:foo, :bar).should be_empty
		    end

		    it 'returns an empty hash when no attributes match the filter' do
		      TestNode.new(:foo => 'foo').attributes_for.should be_empty
		      TestNode.new(:foo => 'foo').attributes_for(:x, :y).should be_empty

		      FooBarNode.new(:foo => 'foo').attributes_for.should be_empty
		      FooBarNode.new(:foo => 'foo').attributes_for(:x, :y).should be_empty
		    end

		    it 'returns a hash of all set attributes that match the filter' do
		      TestNode.new(:foo => 'foo', :bar => 'bar').attributes_for(:x, :foo).should == { :foo => 'foo' }
		      FooBarNode.new(:foo => 'foo', :bar => 'bar').attributes_for(:x, :foo).should == { :foo => 'foo' }
		    end
		  end

		  describe '#formatting_options' do
		    it 'returns an empty hash by default' do
		      TestNode.new.formatting_options.should be_empty
		      FooBarNode.new.formatting_options.should be_empty
		    end

		    it 'returns an empty hash if there are no formatting attributes' do
		      TestNode.new(:foo => 'foo', :bar => 'bar').formatting_options.should be_empty
		      FooBarNode.new(:foo => 'foo', :bar => 'bar').formatting_options.should be_empty
		    end

		    it "returns a hash of the node's formatting attributes" do
		      TestNode.new(:foo => 'foo', :'font-style' => 'italic').formatting_options.should == { :'font-style' => 'italic' }
		    end
		  end

  		describe '#values_at' do
  		  it 'FooBarNode accepts attribute names' do
  		    FooBarNode.new(:foo => 'Foo', :bar => 'Bar').values_at(:bar, :foo).should == %w{ Bar Foo }
  		    FooBarNode.new(:foo => 'Foo').values_at(:bar, :foo).should == [nil, 'Foo']
  		    FooBarNode.new(:foo => 'Foo').values_at(:unknown, :foo).should == [nil, 'Foo']
  		  end

  		  it 'TestNode accepts attribute names' do
  		    TestNode.new(:foo => 'Foo', :bar => 'Bar').values_at(:bar, :foo).should == %w{ Bar Foo }
  		    TestNode.new(:foo => 'Foo').values_at(:bar, :foo).should == [nil, 'Foo']
  		    TestNode.new(:foo => 'Foo').values_at(:unknown, :foo).should == [nil, 'Foo']
  		  end
      end

      describe '#to_a' do
        it 'returns an empty list by default' do
          Node.new.attributes.to_a.should == []
        end

        it 'TestNode returns an empty list by default' do
          TestNode.new.attributes.to_a.should == []
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
          TestNode.new.attributes.keys.should be_empty
          FooBarNode.new.attributes.keys.should == [:foo, :bar]
        end
      end
    end
	end

  describe TextNode do

    it { should_not be nil }
    it { should_not have_children }
    it { should_not have_attributes }

    describe '.new' do
      it 'accepts a hash of attributes' do
        TextNode.new(:foo => 'bar').should have_attributes
      end

      it 'yields itself to the optional block' do
        TextNode.new { |n| n.text = 'foo' }.text.should == 'foo'
      end

      it 'accepts hash and yields itself to the optional block' do
        TextNode.new(:foo => 'bar') { |n| n.text = 'foo' }.to_xml.should == '<text-node foo="bar">foo</text-node>'
      end
    end

    describe '#pretty_print' do
      TextNode.new(:foo => 'bar') { |n| n.text = 'foo' }.pretty_print.should == '<text-node foo="bar">foo</text-node>'
    end
  end

end