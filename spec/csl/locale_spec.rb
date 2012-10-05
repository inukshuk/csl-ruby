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
				Locale.regions[:en].should == :US
			end

		end

		describe '.languages' do

			describe 'the language hash' do
				it 'returns the default language when passed a region string' do
					%w{ US en GB en AT de DE de }.map(&:to_sym).each_slice(2) do |region, language|
						Locale.languages[region].should == language
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
          Locale.normalize(tag).should == expected
        end
      end
		end

		describe '.new' do
			it { should_not be_nil }

			it 'defaults to default language' do
				Locale.new.language.should == Locale.default.split(/-/)[0].to_sym
			end

			it 'defaults to default region' do
				Locale.new.region.should == Locale.default.split(/-/)[1].to_sym
			end

      it 'contains no dates by default' do
        Locale.new.dates.should be_nil
      end

      it 'contains no terms by default' do
        Locale.new.terms.should be_nil
      end

		end

    describe '.load' do

      describe 'when called with "en-GB" ' do
        let(:locale) { Locale.load('en-GB') }

        it 'the returned locale has the correct IETF tag' do
          locale.to_s.should == 'en-GB'
        end

        it 'the locale has language :en' do
          locale.language.should == :en
        end

        it 'the locale has region :GB' do
          locale.region.should == :GB
        end

      end

    end

		describe '#set' do

			it 'when passed "en-GB" sets language to :en and region to :GB' do
				locale.set('en-GB')
				[locale.language, locale.region].should == [:en, :GB]
			end

			it 'when passed "de" sets language to :de and region to :DE' do
				locale.set('de')
				[locale.language, locale.region].should == [:de, :DE]
			end

			it 'when passed "-AT" sets language to :de and region to :AT' do
				locale.set('-AT')
				[locale.language, locale.region].should == [:de, :AT]
			end

		end

		describe '#merge!' do
		  let(:locale_with_options) { Locale.new('en', :foo => 'bar') }

		  describe 'style options' do
  		  it 'does not change the options if none are set on either locale' do
  		    expect { locale.merge!(en) }.not_to change { locale.options }
  		  end

  		  it 'creates a duplicate option element if the first locale has no options' do
  		    locale.should_not have_options
  		    locale.merge!(locale_with_options)
  		    locale.should have_options
  		    locale.options[:foo].should == 'bar'
          locale.options.should_not equal(locale_with_options.options)
  		  end

  		  it 'merges the options if both locales have options' do
  		    locale << Locale::StyleOptions.new(:bar => 'foo')
  		    
  		    expect { locale.merge!(locale_with_options) }.not_to change { locale.options.object_id }
  		    
  		    locale.options[:foo].should == 'bar'
  		    locale.options[:bar].should == 'foo'
  		  end

  		  it 'overrides the options with those in the other locale' do
  		    locale << Locale::StyleOptions.new(:bar => 'foo', :foo => 'foo')
  		    locale.merge!(locale_with_options)
  		    locale.options[:foo].should == 'bar'
  		    locale.options[:bar].should == 'foo'
  		  end
  		end
  		
  		describe 'dates' do
  		  it 'does not change the dates if none are set on either locale' do
  		    expect { locale.merge!(en) }.not_to change { locale.dates }
  		  end
  		  
  		  it 'creates duplicate date elements if the first locale has no options' do
  		    locale.merge!(Locale.load('en-US'))
  		    locale.should have_dates
  		  end
  		end
		end

		describe '#legacy?' do
		  it 'returns false by default' do
		    locale.should_not be_legacy
		  end

		  it 'returns true if the version is less than 1.0.1' do
		    locale.version = '0.8'
		    locale.should be_legacy
		  end
		end

	end
end