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
          m.matches?('month-05').should be_true
        end

        it 'matches the name when passed a pattern' do
          m.matches?(/month-\d\d/).should be_true
        end
        
        it 'does not match when passed a matching hash without gender' do
          f.matches?(:name => 'edition').should_not be_true
        end

        it 'does not match when passed a matching hash with wrong gender' do
          f.matches?(:name => 'edition', :gender => 'masculine').should_not be_true
        end
        
        it 'matches when passed a matching hash with matching gender' do
          f.matches?(:name => 'edition', :gender => 'feminine').should be_true
        end
      end
      
      describe 'attributes#to_a' do
        it 'returns an array of all attribute values' do
          f.attributes.to_a.should == ['edition', nil, 'feminine', nil]
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