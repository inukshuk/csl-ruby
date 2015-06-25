# -*- encoding: utf-8 -*-

require 'spec_helper'

module CSL

  describe Locale do

    let(:locale) { Locale.new }

    let(:en) { Locale.new('en-US') }
    let(:gb) { Locale.new('en-GB') }
    let(:de) { Locale.new('de-DE') }

    describe '.regions' do

      it 'returns the default region when passed a language symbol' do
        expect(Locale.regions[:en]).to eq(:US)
      end

    end

    describe '.languages' do

      describe 'the language hash' do
        it 'returns the default language when passed a region string' do
          %w{ US en GB en AT de DE de }.map(&:to_sym).each_slice(2) do |region, language|
            expect(Locale.languages[region]).to eq(language)
          end
        end
      end

    end

    describe '.normalize' do
      {
        'en' => 'en-US',
        '-GB' => 'en-GB',
        '-BR' => 'pt-BR',
        'de-AT' => 'de-AT'
      }.each_pair do |tag, expected|
        it "converts #{tag.inspect} to #{expected.inspect}" do
          expect(Locale.normalize(tag)).to eq(expected)
        end
      end
    end

    describe '.new' do
      it { is_expected.not_to be_nil }

      it 'has no language' do
        expect(Locale.new.language).to be_nil
      end

      it 'has no region' do
        expect(Locale.new.region).to be_nil
      end

      it 'contains no dates by default' do
        expect(Locale.new.dates).to be_nil
      end

      it 'contains no terms by default' do
        expect(Locale.new.terms).to be_nil
      end

    end

    describe '.load' do

      describe 'when called with "en-GB" ' do
        let(:locale) { Locale.load('en-GB') }

        it 'the returned locale has the correct IETF tag' do
          expect(locale.to_s).to eq('en-GB')
        end

        it 'the locale has language :en' do
          expect(locale.language).to eq(:en)
        end

        it 'the locale has region :GB' do
          expect(locale.region).to eq(:GB)
        end

      end

    end

    describe '.parse' do
      it 'does not set a default language' do
        expect(Locale.parse('<locale/>').language).to be_nil
      end
    end

    describe '#set' do

      it 'when passed "en-GB" sets language to :en and region to :GB' do
        locale.set('en-GB')
        expect([locale.language, locale.region]).to eq([:en, :GB])
      end

      it 'when passed "de" sets language to :de and region to :DE' do
        locale.set('de')
        expect([locale.language, locale.region]).to eq([:de, :DE])
      end

      it 'when passed "-AT" sets language to :de and region to :AT' do
        locale.set('-AT')
        expect([locale.language, locale.region]).to eq([:de, :AT])
      end

    end

    describe '#merge!' do
      let(:locale_with_options) { Locale.new('en', :foo => 'bar') }

      describe 'style options' do
        it 'does not change the options if none are set on either locale' do
          expect { locale.merge!(en) }.not_to change { locale.options }
        end

        it 'creates a duplicate option element if the first locale has no options' do
          expect(locale).not_to have_options
          locale.merge!(locale_with_options)
          expect(locale).to have_options
          expect(locale.options[:foo]).to eq('bar')
          expect(locale.options).not_to equal(locale_with_options.options)
        end

        it 'merges the options if both locales have options' do
          locale << Locale::StyleOptions.new(:bar => 'foo')

          expect { locale.merge!(locale_with_options) }.not_to change { locale.options.object_id }

          expect(locale.options[:foo]).to eq('bar')
          expect(locale.options[:bar]).to eq('foo')
        end

        it 'overrides the options with those in the other locale' do
          locale << Locale::StyleOptions.new(:bar => 'foo', :foo => 'foo')
          locale.merge!(locale_with_options)
          expect(locale.options[:foo]).to eq('bar')
          expect(locale.options[:bar]).to eq('foo')
        end
      end

      describe 'dates' do
        it 'does not change the dates if none are set on either locale' do
          expect { locale.merge!(en) }.not_to change { locale.dates }
        end

        it 'creates duplicate date elements if the first locale has no options' do
          locale.merge!(Locale.load('en-US'))
          expect(locale).to have_dates
        end

        it 'merges dates of both locales' do
          locale << Locale::Date.new(:form => 'numeric')

          other = Locale.load('en-US')
          locale.merge! other

          expect(locale.dates.length).to eq(other.dates.length)
        end
      end

      describe 'terms' do
        let(:us) { Locale.load('en-US') }

        it 'does not change the terms if none are set on either locale' do
          expect { locale.merge!(Locale.new) }.not_to change { locale.terms.to_s }
        end

        it 'overrides terms with those of the other locale' do
          expect(locale).not_to have_terms

          locale.merge! us
          expect(locale).to have_terms
        end

        it 'makes copies of the terms' do
          locale.merge! us
          expect(locale).to have_terms

          expect(locale.terms.first).to eq(us.terms.first)
          expect(locale.terms.first).not_to be(us.terms.first)
        end
      end
    end

    describe '#legacy?' do
      it 'returns false by default' do
        expect(locale).not_to be_legacy
      end

      it 'returns true if the version is less than 1.0.1' do
        locale.version = '0.8'
        expect(locale).to be_legacy
      end
    end

    describe '#quote' do

      it 'quotes the passed-in string' do
        locale.store 'open-quote', '»'
        locale.store 'close-quote', '«'

        expect(locale.quote('foo')).to eq('»foo«')
      end

      it 'does not alter the string if there are no quotes in the locale' do
        expect(locale.quote('foo')).to eq('foo')
      end

      it 'adds quotes inside final punctuation if punctuation-in-quote option is set' do
        locale.store 'open-quote', '»'
        locale.store 'close-quote', '«'

        expect(locale.quote('foo.')).to eq('»foo«.')
        expect(locale.quote('foo,')).to eq('»foo«,')

        expect(locale.quote('foo!')).to eq('»foo!«')
        expect(locale.quote('foo?')).to eq('»foo?«')

        locale.punctuation_in_quotes!

        expect(locale.quote('foo.')).to eq('»foo.«')
        expect(locale.quote('foo,')).to eq('»foo,«')

        expect(locale.quote('foo!')).to eq('»foo!«')
        expect(locale.quote('foo?')).to eq('»foo?«')
      end

      it 'replaces existing quotes with inner quotes' do
        locale.store 'open-quote', '“'
        locale.store 'close-quote', '”'
        locale.store 'open-inner-quote', '‘'
        locale.store 'close-inner-quote', '’'

        expect(locale.quote('“foo”')).to eq('“‘foo’”')
      end
    end
  end
end
