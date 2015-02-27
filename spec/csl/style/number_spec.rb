require 'spec_helper'

module CSL
  describe Style::Number do

    describe '.new' do
      it 'returns an empty number tag by default' do
        expect(Style::Number.new.attributes).to be_empty
      end

      it 'accepts a form attribute' do
        expect(Style::Number.new(:form => 'roman')).to be_roman
      end
    end

    describe '#numeric?' do
      it 'returns true by default' do
        expect(Style::Number.new).to be_numeric
      end

      it 'returns false if the form attribute is set to a value other than :numeric' do
        expect(Style::Number.new(:form => 'foo')).not_to be_numeric
      end

      it 'returns false if the form attribute is set to :numeric' do
        expect(Style::Number.new(:form => 'numeric')).to be_numeric
      end
    end

    describe '#roman?' do
      it 'returns false by default' do
        expect(Style::Number.new).not_to be_roman
      end

      it 'returns false if the form attribute is set to a value other than :numeric' do
        expect(Style::Number.new(:form => 'ordinal')).not_to be_roman
      end

      it 'returns false if the form attribute is set to :roman' do
        expect(Style::Number.new(:form => 'roman')).to be_roman
      end
    end

    describe '#ordinal?' do
      it 'returns false by default' do
        expect(Style::Number.new).not_to be_ordinal
      end

      it 'returns false if the form attribute is set to a value other than :ordinal' do
        expect(Style::Number.new(:form => 'long-ordinal')).not_to be_ordinal
      end

      it 'returns false if the form attribute is set to :ordinal' do
        expect(Style::Number.new(:form => 'ordinal')).to be_ordinal
        expect(Style::Number.new(:form => :ordinal)).to be_ordinal
      end
    end

    describe '#long_ordinal?' do
      it 'returns false by default' do
        expect(Style::Number.new).not_to be_long_ordinal
      end

      it 'returns false if the form attribute is set to a value other than :"long-ordinal"' do
        expect(Style::Number.new(:form => 'ordinal')).not_to be_long_ordinal
      end

      it 'returns false if the form attribute is set to :ordinal' do
        expect(Style::Number.new(:form => 'long-ordinal')).to be_long_ordinal
      end
    end


    describe '#to_xml' do
      it 'returns an empty number tag by default' do
        expect(Style::Number.new.to_xml).to eq('<number/>')
      end

      it 'returns a tag with a all attribute assignments' do
        expect(Style::Number.new(:form => 'roman').to_xml).to eq('<number form="roman"/>')
      end
    end

  end
end
