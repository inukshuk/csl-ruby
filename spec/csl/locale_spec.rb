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
        'de-AT' => 'de-AT',
        'de-aT' => 'de-AT',
        'bal-PK' => 'bal-PK',
        'sr-RS' => 'sr-Latn-RS',
        'sr' => 'sr-Latn-RS',
        '-RS' => 'sr-Latn-RS',
        'sr-latn-rs' => 'sr-Latn-RS',
        'sr-Cyrl-RS' => 'sr-Cyrl-RS'
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

      it 'has no script' do
        expect(Locale.new.script).to be_nil
      end

      it 'contains no dates by default' do
        expect(Locale.new.dates).to be_nil
      end

      it 'contains no terms by default' do
        expect(Locale.new.terms).to be_nil
      end

    end

    describe '.load' do

      describe 'locale fallback' do
        it 'falls back to the primary dialect' do
          expect(Locale.load('de-AT').to_s).to eq('de-DE')
          expect(Locale.load('de-XX').to_s).to eq('de-DE')
        end

        it 'falls back to the default locale' do
          expect(Locale.load('gx').to_s).to eq('en-US')
          expect(Locale.load('xx-YY').to_s).to eq('en-US')
        end

        it 'ignores extensions and private-use subtags' do
          expect(Locale.load('en-US-x-sort-ja-alalc97').to_s).to eq('en-US')
          expect(Locale.load('de-AT-u-co-phonebk').to_s).to eq('de-DE')
        end

        it 'does not fall back for file paths' do
          expect { Locale.load('spec/fixtures/locales/locales-xx-YY.xml') }.to raise_error(ParseError)
        end

        it 'remembers the requested tag' do
          expect(Locale.load('de-AT').requested).to eq('de-AT')
          expect(Locale.load('gx').requested).to eq('gx')
          expect(Locale.load('de').requested).to eq('de-DE')
          expect(Locale.load('en-US-x-sort-ja').requested).to eq('en-US')
        end

        it 'does not set the requested tag for file paths' do
          expect(Locale.load('spec/fixtures/locales/locales-de-DE.xml').requested).to be_nil
        end

        it 'knows whether or not it is a fallback' do
          expect(Locale.load('de-AT')).to be_fallback
          expect(Locale.load('de-DE')).not_to be_fallback
          expect(Locale.new('de-DE')).not_to be_fallback
        end

        it 'keeps the requested tag in copies' do
          expect(Locale.load('gx').deep_copy.requested).to eq('gx')
          expect(Locale.load('gx').merge(Locale.new('de')).requested).to eq('gx')
        end
      end

      it 'loads locales from relative file paths' do
        expect(Locale.load('spec/fixtures/locales/locales-de-DE.xml').to_s).to eq('de-DE')
      end

      it 'loads locales from URLs' do
        url = 'https://example.com/locales/locales-de-DE.xml'
        xml = File.read('spec/fixtures/locales/locales-de-DE.xml')

        expect(URI).to receive(:open).with(url, 'r:UTF-8').and_yield(StringIO.new(xml))
        expect(Locale.load(url).to_s).to eq('de-DE')
      end

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
        expect([locale.language, locale.region, locale.script]).to eq([:en, :GB, nil])
      end

      it 'when passed "de" sets language to :de and region to :DE' do
        locale.set('de')
        expect([locale.language, locale.region, locale.script]).to eq([:de, :DE, nil])
      end

      it 'when passed "-AT" sets language to :de and region to :AT' do
        locale.set('-AT')
        expect([locale.language, locale.region, locale.script]).to eq([:de, :AT, nil])
      end

      it 'when passed "bal-PK" sets language to :bal and region to :PK' do
        locale.set('bal-PK')
        expect([locale.language, locale.region, locale.script]).to eq([:bal, :PK, nil])
      end

      it 'when passed "sr" sets language, region, and script' do
        locale.set('sr')
        expect([locale.language, locale.region, locale.script]).to eq([:sr, :RS, :Latn])
      end
    end

    describe '#like?' do
      it 'is true for locales of the same language' do
        expect(Locale.new('de-DE')).to be_like(Locale.new('de-AT'))
        expect(Locale.new('de-DE')).not_to be_like(Locale.new('en-US'))
      end

      it 'is true for universal locales' do
        expect(Locale.new('de-DE')).to be_like(Locale.new.clear)
      end

      it 'uses the requested language of fallback locales' do
        locale = Locale.load('gx')

        expect(locale).to be_like(Locale.new('gx'))
        expect(locale).not_to be_like(Locale.new('en-US'))
      end
    end

    describe '#<=>' do
      it 'sorts the default locale and primary dialects first' do
        locales = %w{ fr-FR de-AT en-GB de-DE en-US }.map { |tag| Locale.new(tag) }
        expect(locales.sort.map(&:to_s)).to eq(%w{ en-US de-DE de-AT en-GB fr-FR })
      end

      it 'ignores locale data' do
        customized = Locale.load('en-US').tap { |l| l.store 'editor', 'EDITOR' }
        expect(customized).to eq(Locale.load('en-US'))
      end

      it 'compares the locales fallback locales were requested for' do
        expect(Locale.load('gx')).not_to eq(Locale.load('en-US'))
        expect(Locale.load('de-AT')).not_to eq(Locale.load('de-DE'))
        expect(Locale.load('de')).to eq(Locale.load('de-DE'))
        expect(Locale.load('gx')).to eq(Locale.load('gx'))
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

        it 'replaces all ordinals if the other locale has ordinals' do
          locale.merge! us

          other = Locale.new
          other.store Locale::Term.new(:name => 'ordinal-01', :'gender-form' => 'feminine') { |t| t.text = '.ª' }
          locale.merge! other

          expect(locale.ordinalize(1)).to eq('1.ª')
          expect(locale.ordinalize(2)).to eq('2')
        end

        it 'makes copies of the terms' do
          locale.merge! us
          expect(locale).to have_terms

          expect(locale.terms.first).to eq(us.terms.first)
          expect(locale.terms.first).not_to be(us.terms.first)
        end
      end
    end

    describe '#ordinalize' do
      # The example from the CSL specification (Gender-specific Ordinals)
      let(:fr) do
        Locale.parse <<-EOS
          <locale xml:lang="fr-FR">
            <terms>
              <term name="edition" gender="feminine">
                <single>édition</single>
                <multiple>éditions</multiple>
              </term>
              <term name="edition" form="short">éd.</term>
              <term name="month-01" gender="masculine">janvier</term>
              <term name="ordinal">e</term>
              <term name="ordinal-01" gender-form="feminine" match="whole-number">re</term>
              <term name="ordinal-01" gender-form="masculine" match="whole-number">er</term>
            </terms>
          </locale>
        EOS
      end

      it 'uses the ordinal of the given gender-form' do
        expect(fr.ordinalize(1, :'gender-form' => 'feminine')).to eq('1re')
        expect(fr.ordinalize(1, :'gender-form' => 'masculine')).to eq('1er')
      end

      it 'falls back to the neuter ordinal' do
        expect(fr.ordinalize(3, :'gender-form' => 'feminine')).to eq('3e')
      end

      it 'uses the gender of the noun' do
        expect(fr.ordinalize(1, :noun => 'edition')).to eq('1re')
        expect(fr.ordinalize(1, :noun => 'month-01')).to eq('1er')
        expect(fr.ordinalize(3, :noun => 'edition')).to eq('3e')
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

    describe '#punctuation_in_quote?' do
      it 'returns false by default' do
        expect(locale).not_to be_punctuation_in_quote
      end

      it 'returns true if the option is set to true' do
        locale << Locale::StyleOptions.new(:'punctuation-in-quote' => '1')
        expect(locale).to be_punctuation_in_quote
      end
    end

    describe '#limit_day_ordinals?' do
      it 'returns true if the option is set to true' do
        locale << Locale::StyleOptions.new(:'limit-day-ordinals-to-day-1' => '1')
        expect(locale).to be_limit_day_ordinals
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
