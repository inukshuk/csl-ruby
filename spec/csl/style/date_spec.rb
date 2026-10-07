require 'spec_helper'

module CSL
  describe Style::Date do
    let(:locale) do
      Locale.parse <<-EOS
        <locale xml:lang="en">
          <date form="text" delimiter=" ">
            <date-part name="month" suffix=","/>
            <date-part name="day"/>
            <date-part name="year"/>
          </date>
        </locale>
      EOS
    end

    describe 'given a non-localized date' do
      subject do
        Style::Date.new(:delimiter => '/') { |d| d << Style::DatePart.new(:name => 'year') }
      end

      it 'uses its own date parts and delimiter' do
        expect(subject.parts_for(locale).map(&:name)).to eq(['year'])
        expect(subject.delimiter_for(locale)).to eq('/')
      end
    end

    describe 'given a localized date' do
      subject { Style::Date.new(:form => 'text', :'date-parts' => 'year-month') }

      it 'uses the date parts and delimiter of the localized date' do
        expect(subject.parts_for(locale).map(&:name)).to eq(['month', 'year'])
        expect(subject.delimiter_for(locale)).to eq(' ')
      end

      it 'overrides the localized date parts except for affixes' do
        subject << Style::DatePart.new(:name => 'month', :form => 'short', :prefix => '(')
        month = subject.parts_for(locale)[0]

        expect(month[:form]).to eq('short')
        expect(month[:suffix]).to eq(',')
        expect(month[:prefix]).to be_nil
      end

      it 'does not change the locale' do
        subject << Style::DatePart.new(:name => 'month', :form => 'short')
        subject.parts_for(locale)

        expect(locale.each_date.first.parts[0][:form]).to be_nil
      end

      it 'fails if the locale has no date in the same form' do
        subject[:form] = 'numeric'
        expect { subject.parts_for(locale) }.to raise_error(Error)
      end
    end
  end

  describe Style::DatePart do

    describe '#numeric-leading-zeros?' do
      
      it { is_expected.not_to be_numeric_leading_zeros }
      
      it 'returns true when the form is set accordingly' do
        subject[:form] = 'numeric-leading-zeros'
        expect(subject).to be_numeric_leading_zeros
      end
    end

  end
end