require 'spec_helper'

module CSL
  describe Style::Label do

    it { is_expected.not_to be_names_label }
    it { is_expected.not_to be_always_pluralize }
    it { is_expected.not_to be_never_pluralize }

    describe '.terms' do
      Hash[*%w{
        page              page
        issue             issue
        edition           edition
        number-of-pages   page
        number-of-volumes volume
        chapter-number    chapter
      }].each do |variable, term|
        it "returns #{term.inspect} for #{variable.inspect}" do
          expect(Style::Label.terms[variable]).to eq(term)
        end
      end
    end

    describe 'a label inside a names node' do
      before(:each) { Style::Names.new << subject }

      it { is_expected.to be_names_label }
    end

    describe '#term' do
      it { is_expected.to be_empty }

      it 'returns the term for the current variable' do
        subject[:variable] = 'page'
        expect(subject.term).to eq('page')

        subject[:variable] = 'number-of-volumes'
        expect(subject.term).to eq('volume')
      end
    end

  end
end