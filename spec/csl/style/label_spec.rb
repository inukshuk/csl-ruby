require 'spec_helper'

module CSL
  describe Style::Label do

    it { should_not be_names_label }
    it { should_not be_always_pluralize }
    it { should_not be_never_pluralize }

    describe '.terms' do
      Hash[%w{
        page              page
        issue             issue
        edition           edition
        number-of-pages   page
        number-of-volumes volume
        chapter-number    chapter
      }].each do |variable, term|
        it "returns #{term.inspect} for #{variable.inspect}" do
          Label.terms[variable].should == term
        end
      end
    end

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

    describe '#term' do
      it { should be_empty }

      it 'returns the term for the current variable' do
        subject[:variable] = 'page'
        subject.term.should == 'page'

        subject[:variable] = 'number-of-volumes'
        subject.term.should == 'volume'
      end
    end

  end
end