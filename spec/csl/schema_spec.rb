require 'spec_helper'

module CSL
  describe 'Schema' do

    it 'cannot be instantiated' do
      expect(Schema).not_to respond_to(:new)
    end

    describe '.version' do
      it 'returns a version string' do
        expect(Schema.version).to match(/^\d+\.\d+\.\d+/)
      end

      it 'is greater than 1.0' do
        expect(Schema.version.split(/\./)[0].to_i).to be >= 1
      end
    end

    describe '.variables' do
      it 'contains :names fields' do
        expect(Schema.variables[:names]).not_to be_empty
        expect(Schema.variables[:name]).to equal Schema.variables[:names]
      end

      it 'contains :date fields' do
        expect(Schema.variables[:date]).not_to be_empty
        expect(Schema.variables[:dates]).to equal Schema.variables[:date]
      end

      it 'contains :text fields' do
        expect(Schema.variables[:text]).not_to be_empty
      end

      it 'contains :number fields' do
        expect(Schema.variables[:numbers]).not_to be_empty
        expect(Schema.variables[:number]).not_to be_empty
      end

      it 'accepts either string or symbol input' do
        expect(Schema.variables[:names]).to equal Schema.variables['names']
      end
    end

    describe '.types' do
      it 'returns an array' do
        expect(Schema.types).to be_a(Array)
      end

      it 'is not empty' do
        expect(Schema.types).not_to be_empty
      end

      it 'includes :article' do
        expect(Schema.types).to include(:article)
      end
    end

    describe '.categories' do
      it 'given a field name returns the corresponding type' do
        expect(Schema.categories.values_at(:author, :issued, :abstract, :issue)).to eq(
          [:names, :date, :text, :number]
        )
      end

      it 'accepts either string or symbol input' do
        expect(Schema.categories).to have_key(:author)
        expect(Schema.categories['author']).to equal Schema.categories[:author]
      end
    end

    describe '.validate' do
      it 'accepts and validates a locale instance' do
        expect(Schema.validate(Locale.load('en-US'))).to eq([])
      end

      it 'accepts and validates a locale file path' do
        expect(Schema.validate(File.join(Locale.root, 'locales-en-US.xml'))).to eq([])
      end

      it 'accepts and validates a locale file' do
        expect(Schema.validate(File.open(File.join(Locale.root, 'locales-en-US.xml')))).to eq([])
      end

      it 'accepts and validates a locale wildcard path' do
        expect(Schema.validate(File.join(Locale.root, 'locales-en-*.xml'))).to eq([])
      end

      it 'accepts and validates a style file path' do
        expect(Schema.validate(File.join(Style.root, 'apa.csl'))).to eq([])
      end

      it 'accepts and validates the xml contents of a style instance' do
        expect(Schema.validate(Style.load(:apa).pretty_print)).to eq([])
      end

      it 'accepts and validates a style instance' do
        expect(Schema.validate(Style.load(:apa))).to eq([])
      end

      it 'does not accept invalid xml markup' do
        expect(Schema.validate(%Q{
         <style xmlns="http://purl.org/net/xbiblio/csl" class="note" version="1.0">
         </stle>
        })[0][0]).to eq(0) # error on line 0 -> parse error
      end

    # TODO fix nokogiri/jing validation
    end unless RUBY_PLATFORM =~ /java/i

  end
end
