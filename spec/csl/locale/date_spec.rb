require 'spec_helper'

module CSL

  describe Locale::Date do

    let(:date) { Locale::Date.new }

    it { is_expected.not_to be_nil }

    it { is_expected.to be_text }
    it { is_expected.not_to be_numeric }

    describe '#parts' do

      it 'returns nil by default' do
        expect(date.parts).to be_empty
      end

    end

    describe '#to_xml' do

      it 'returns <date/> by default' do
        expect(Locale::Date.new.to_xml).to eq('<date/>')
      end

      it 'returns <date form="numeric"/> for an empty numeric date' do
        expect(Locale::Date.new(:form => 'numeric').to_xml).to eq('<date form="numeric"/>')
      end

    end

  end

  describe Locale::DatePart do

    it { is_expected.not_to be_nil }

    it { is_expected.not_to be_day }
    it { is_expected.not_to be_month }
    it { is_expected.not_to be_year }

    describe '#to_xml' do

      it 'returns <date-part/> by default' do
        expect(Locale::DatePart.new.to_xml).to eq("<date-part/>")
      end

      it 'returns <date-part name="year"/> when the name is "year"' do
        expect(Locale::DatePart.new(:name => 'year').to_xml).to eq('<date-part name="year"/>')
      end

      it 'returns <date-part name="month" form="numeric" prefix="-"/> for a numeric month with prefix "-"' do
        expect(Locale::DatePart.new(:name => 'month', :form => 'numeric', :prefix => '-').to_xml).to match(/(\s(name|form|prefix)="[^"]+"){3}/)
      end

    end

  end


end
