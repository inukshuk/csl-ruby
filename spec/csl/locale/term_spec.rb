require 'spec_helper'

module CSL
  describe Locale::Terms do
	
		it { should_not be nil }

		describe '#to_xml' do
			it 'returns <terms/> by default' do
				subject.to_xml.should == '<terms/>'
			end
		end
		
	end
	
  describe Locale::Term do

    it { should_not be_nil }

    it { should_not be_gendered }

    it { should be_neutral }

		it 'is not a textnode by default' do
			subject.should_not be_textnode
		end

		it 'is a textnode when the text is "foo"' do
			Locale::Term.new { |t| t.text = 'foo' }.should be_textnode
		end

    describe 'gender attribute is set' do
      let(:m) { Locale::Term.new(:name => 'month-05') { |t| t.masculine!; t.text = 'Mai' } } 
      let(:f) { Locale::Term.new(:name => 'edition') { |t| t.feminine!; t.text = 'Ausgabe' } } 
      
      it 'is gendered' do
        m.should be_gendered
        f.should be_gendered
      end

      it 'is feminine or masculine' do
        m.should be_masculine
        f.should be_feminine
      end
      
      it 'is not neutral' do
        m.should_not be_neutral
        f.should_not be_neutral
      end
      
      describe '#to_xml' do
        it 'contains the correct gender' do
          m.to_xml.should =~ /gender="masculine"/
          f.to_xml.should =~ /gender="feminine"/
        end
      end
      
      describe '#match?' do
        it 'matches the name when passed a string' do
          m.should be_match(:name => 'month-05')
        end

        it 'matches the name when passed a pattern' do
          m.should be_match(:name => /month-\d\d/)
        end
        
        it 'matches when passed a matching hash without gender' do
          f.should be_match(:name => 'edition')
        end

        it 'does not match when passed a matching hash with wrong gender' do
          f.matches?(:name => 'edition', :gender => 'masculine').should_not be_true
        end
        
        it 'matches when passed a matching hash with matching gender' do
          f.matches?(:name => 'edition', :gender => 'feminine').should be_true
        end
      end

      describe '#exact_match?' do
        it 'does not match when passed a matching hash without gender' do
          f.should_not be_exact_match(:name => 'edition')
        end
      end
      
      describe 'attributes#to_a' do
        it 'returns an array of all attribute values of underlying struct' do
          f.attributes.to_a.should == ['edition', nil, 'feminine', nil]
        end
      end
    end
    
    describe '#to_s' do
      it 'returns an empty string by default' do
        Locale::Term.new.to_s.should == ''
      end
      
      describe 'given a simple term' do
        let(:node) { Locale::Term.new { |t| t.text = 'foo' } }
        
        it "returns the term's text" do
          node.to_s.should == node.text
        end
      end

      describe 'given a compound term' do
        let(:node) { Locale::Term.new { |t| t.single = 'shoe'; t.multiple = 'shoes' } }

        it "returns the term's singular form by default" do
          node.to_s.should == node.singularize
        end
        
        it "returns the term's plural form when passed :number => :plural" do
          node.to_s(:number => :plural).should == node.pluralize
        end

        it "returns the term's plural form when passed :number => 2" do
          node.to_s(:number => 2).should == node.pluralize
        end

        it "returns the term's singular form when passed :number => 1" do
          node.to_s(:number => 1).should == node.singularize
        end

        it "returns the term's plural form when passed :plural => true" do
          node.to_s(:plural => true).should == node.pluralize
        end

      end
    end
    
		describe '#to_xml' do
			it 'returns <term/> by default' do
				subject.to_xml.should == '<term/>'
			end
			
			it 'returns <term>foo</term> when the text is "foo"' do
				Locale::Term.new { |t| t.text = 'foo' }.to_xml.should == '<term>foo</term>'
			end

			it 'returns <term><multiple>foo</multiple></term> when multiple is "foo"' do
				Locale::Term.new { |t| t.multiple = 'foo' }.to_xml.should == '<term><multiple>foo</multiple></term>'
			end
			
		end
  end
end