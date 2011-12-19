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