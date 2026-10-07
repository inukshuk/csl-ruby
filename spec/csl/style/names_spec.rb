require 'spec_helper'

module CSL
  describe Style::Names do

  end

  describe Style::Name do

    it { is_expected.to be_delimiter_contextually_precedes_last }
    it { is_expected.to be_delimiter_contextually_precedes_et_al }

    it 'uses an ellipsis if et-al-use-last is true' do
      expect(subject).not_to be_ellipsis

      subject[:'et-al-use-last'] = '1'
      expect(subject).to be_ellipsis
    end

    [:never, :always, :contextually].each do |setting|
      setter = "delimiter_#{setting}_precedes_last!"
      predicate = "delimiter_#{setting}_precedes_last?"

      describe "##{setter}" do
        it 'sets the delimiter precedes last option accordingly' do
          expect(subject.send(setter).send(predicate)).to eq(true)
        end
      end
    end

  end

  describe Style::NamePart do

  end

  describe Style::EtAl do

  end

  describe Style::Substitute do

  end
end