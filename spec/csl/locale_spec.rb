# -*- encoding: utf-8 -*-

require 'spec_helper'

module CSL

	describe Locale do

		let(:locale) { Locale.new }

		let(:en) { Locale.new('en-US') }
		let(:de) { Locale.new('de-DE') }
		let(:fr) { Locale.new('fr-FR') }

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
		
		describe '.new' do
			it { should_not be_nil }

			it 'defaults to default language' do
				Locale.new.language.should == Locale.default.split(/-/)[0].to_sym
			end

			it 'defaults to default region' do
				Locale.new.region.should == Locale.default.split(/-/)[1].to_sym
			end

      it 'has the default options by default' do
        Locale.new.options.should == Locale.options
      end

			[:terms, :dates].each do |m|
				it "contains no #{m} by default" do
					Locale.new.send(m).should_not be_nil
					Locale.new.send(m).should be_empty
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
		
	end
end