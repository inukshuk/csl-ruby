require 'spec_helper'

module CSL
	
	describe Node do

    it { should_not be nil }
    it { should_not have_children }
    it { should_not have_attributes }
		
		describe '#' do
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
    
  end
  
end