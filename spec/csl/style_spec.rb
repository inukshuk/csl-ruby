require 'spec_helper'

module CSL
  describe Style do
    let(:style) { Style.new }
  
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

    describe '#children' do
    
      it { should_not have_info }
      it { should_not have_locale }
      it { should_not have_macro }
      it { should_not have_citation }
      it { should_not have_bibliography }
      
      describe 'when it has a title' do
        before(:all) { style.title = 'foo' }
        
        it { style.should have_info }
        
        it 'info.title is a text node' do
          style.info.title.should be_a(TextNode)
        end
        
        it '#title returns the title as a string' do
          style.title.should be_a(String)
        end
      end
    end
    
    describe '#id accessor' do
      it 'returns nil by default' do
        Style.new.id.should be_nil
      end
      
      it 'writer sets the id to the passed-in string' do
        expect { style.id = 'foobar' }.to change { style.id }.from(nil).to('foobar')
      end
    end
    
    describe 'independent and dependent styles' do
      it 'styles are independent by default' do
        Style.new.should be_independent
      end
      
      it 'styles do not have independent-parent links by default' do
        Style.new.should_not have_independent_parent_link
      end
      
      it 'when setting an independet-parent link a style becomes dependent' do
        expect { style.independent_parent_link = 'foo' }.to change { style.independent? }
      end
    end
  end
end
