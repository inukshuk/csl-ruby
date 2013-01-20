require 'spec_helper'

module CSL  
  describe Locale::StyleOptions do
  
    it { should_not be nil }
    
    it 'punctuation-in-quote is false by default' do
      subject[:'punctuation-in-quote'].should be false
    end
    
    describe '#to_xml' do
      it 'returns <style-options punctuation-in-quote="false"/> by default' do
        subject.to_xml.should =~ /<style-options\/>/
      end
    end
    
  end
end