require 'spec_helper'

module CSL
  describe Style::Label do
    
    it { should_not be_names_label }
    it { should_not be_always_pluralize }
    it { should_not be_never_pluralize }
    
    describe 'a label inside a names node' do
      before(:each) { Style::Names.new << subject }
      
      it { should be_names_label }
      
      describe '#variable' do
        before(:each) { subject.parent[:variable] = 'editor' }

        it 'returns the names variable(s)' do
          subject.variable.should == 'editor'
        end
        
        it 'returns the names variable(s) even when the local attribute is set' do
          subject[:variable] = 'page'
          subject.variable.should == 'editor'
        end
      end
    end
  end
end