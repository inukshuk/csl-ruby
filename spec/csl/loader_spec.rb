require 'spec_helper'

module CSL
  describe Loader do
    let(:xml) { Style.load(:apa).to_xml }

    describe 'loading from a URL' do
      let(:url) { 'https://www.zotero.org/styles/apa' }

      it 'is allowed by default' do
        expect(Loader.allow_remote).to be true
      end

      it 'fetches the data via open-uri' do
        expect(URI).to receive(:open).with(url, 'r:UTF-8').and_yield(StringIO.new(xml))
        expect(Style.load(url).title).to eq(Style.load(:apa).title)
      end

      describe 'when remote loading is disabled' do
        around do |example|
          Loader.allow_remote = false
          example.run
        ensure
          Loader.allow_remote = true
        end

        it 'does not fetch the data' do
          expect(URI).not_to receive(:open)
          expect { Style.load(url) }.to raise_error(ParseError, /disabled/)
          expect { Locale.load('https://example.com/locales-de-DE.xml') }.to raise_error(ParseError, /disabled/)
        end

        it 'still loads styles by name' do
          expect(Style.load(:apa)).to be_a(Style)
        end
      end
    end

    describe 'loading from a file name' do
      it 'does not execute commands' do
        expect(Kernel).not_to receive(:open)
        expect { Style.load('|echo <style/>') }.to raise_error(ParseError)
      end
    end
  end
end
