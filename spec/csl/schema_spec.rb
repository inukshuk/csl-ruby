require 'spec_helper'

module CSL
  describe 'Schema' do
  
    it 'cannot be instantiated' do
      Schema.should_not respond_to(:new)
    end
    
    describe '.version' do
      it 'returns a version string' do
        Schema.version.should match(/^\d+\.\d+\.\d+/)
      end
      
      it 'is greater than 1.0' do
        Schema.version.split(/\./)[0].to_i.should >= 1
      end
    end
    
    describe '.variables' do
      it 'contains :names fields' do
        Schema.variables[:names].should_not be_empty
        Schema.variables[:name].should equal Schema.variables[:names]
      end

      it 'contains :date fields' do
        Schema.variables[:date].should_not be_empty
        Schema.variables[:dates].should equal Schema.variables[:date]
      end

      it 'contains :text fields' do
        Schema.variables[:text].should_not be_empty
      end

      it 'contains :number fields' do
        Schema.variables[:numbers].should_not be_empty
        Schema.variables[:number].should_not be_empty
      end
      
      it 'accepts either string or symbol input' do
        Schema.variables[:names].should equal Schema.variables['names']
      end  
    end
    
    describe '.types' do
      it 'returns an array' do
        Schema.types.should be_a(Array)
      end
      
      it 'is not empty' do
        Schema.types.should_not be_empty
      end
      
      it 'includes :article' do
        Schema.types.should include(:article)
      end
    end
    
    describe '.categories' do
      it 'given a field name returns the corresponding type' do
        Schema.categories.values_at(:author, :issued, :abstract, :issue).should ==
          [:names, :date, :text, :number]
      end
      
      it 'accepts either string or symbol input' do
        Schema.categories.should have_key(:author)
        Schema.categories['author'].should equal Schema.categories[:author]
      end
    end
    
    describe '.validate' do
      it 'accepts and validates a locale instance' do
        Schema.validate(Locale.load('en-US')).should == []
      end
      
      it 'accepts and validates a locale file path' do
        Schema.validate(File.join(Locale.root, 'locales-en-US.xml')).should == []
      end

      it 'accepts and validates a locale file' do
        Schema.validate(File.open(File.join(Locale.root, 'locales-en-US.xml'))).should == []
      end

      it 'accepts and validates a locale wildcard path' do
        Schema.validate(File.join(Locale.root, 'locales-en-*.xml')).should == []
      end

      it 'accepts and validates a style file path' do
        Schema.validate(File.join(Style.root, 'apa.csl')).should == []
      end

      it 'accepts and validates a style instance' do
        Schema.validate(Style.load(:apa)).should == []
      end
      
    end
    
  end
end