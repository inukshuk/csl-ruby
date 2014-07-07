require 'spec_helper'

module CSL  
  describe Locale::StyleOptions do
  
    it { is_expected.not_to be nil }
    
    it 'punctuation-in-quote is false by default' do
      expect(subject[:'punctuation-in-quote']).to be false
    end
    
    describe '#to_xml' do
      it 'returns <style-options punctuation-in-quote="false"/> by default' do
        expect(subject.to_xml).to match(/<style-options\/>/)
      end
    end
    
  end
end