require 'spec_helper'

module CSL
  describe Style do
  
    it 'has a 1.x version by default' do
      Style.new[:version].should match(/1\.\d+(\.\d+)?/) 
    end
    
    describe '#to_xml' do
      it 'returns an empty style' do
        Style.new.to_xml.should match(/<style[^>]*\/>/)
      end
      
      it 'supports round-trip for apa style' do
        Style.parse(Style.load(:apa).to_xml).should be_a(Style)
      end
    end
  
  end
end
