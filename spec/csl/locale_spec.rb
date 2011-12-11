# -*- encoding: utf-8 -*-

require 'spec_helper'

module CSL

	describe Locale do

		let(:locale) { Locale.new }

		let(:en) { Locale.new('en-US') }
		let(:de) { Locale.new('de-DE') }
		let(:fr) { Locale.new('fr-FR') }

		describe '.region' do
			
			it 'returns a hash frozen hash' do
				Locale.region.should be_frozen
			end
		
			describe 'the region hash' do
				it 'returns the default region when passed a language string' do
					Locale.region['en'].should == 'US'
				end
			end
			
		end
		
		describe '.language' do
			
			it 'returns a hash frozen hash' do
				Locale.language.should be_frozen
			end

			describe 'the language hash' do
				it 'returns the default language when passed a region string' do
					Hash[*%w{ US en GB en AT de DE de }].each do |region, language|
						Locale.language[region].should == language
					end
				end
			end			
			
		end
		
		describe '.new' do
			it { should_not be_nil }

			it 'defaults to empty language' do
				locale.language.should be_nil
			end

			it 'defaults to empty region' do
				locale.region.should be_nil
			end

			[:terms, :date, :options].each do |m|
				it "contains no #{m} by default" do
					locale.send(m).should_not be_nil
					locale.send(m).should be_empty
				end
			end

		end

		describe '#language=' do

			it 'sets the language when passed language' do
				locale.language = 'de'
				locale.language.should == language
			end

			it 'sets default region for language when passed language' do
				locale.language = 'de'
				locale.region.should == 'DE'      
			end

		end

	end
end