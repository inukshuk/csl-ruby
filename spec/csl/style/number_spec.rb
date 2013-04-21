require 'spec_helper'

module CSL
  describe Style::Number do
  
    describe '.new' do
      it 'returns an empty number tag by default' do
        Style::Number.new.should_not have_attributes
      end
      
      it 'accepts a form attribute' do
        Style::Number.new(:form => 'roman').should be_roman
      end
    end
    
    describe '#numeric?' do
      it 'returns true by default' do
        Style::Number.new.should be_numeric
      end
      
      it 'returns false if the form attribute is set to a value other than :numeric' do
        Style::Number.new(:form => 'foo').should_not be_numeric
      end
      
      it 'returns false if the form attribute is set to :numeric' do
        Style::Number.new(:form => 'numeric').should be_numeric
      end
    end

    describe '#roman?' do
      it 'returns false by default' do
        Style::Number.new.should_not be_roman
      end
      
      it 'returns false if the form attribute is set to a value other than :numeric' do
        Style::Number.new(:form => 'ordinal').should_not be_roman
      end
      
      it 'returns false if the form attribute is set to :roman' do
        Style::Number.new(:form => 'roman').should be_roman
      end
    end

    describe '#ordinal?' do
      it 'returns false by default' do
        Style::Number.new.should_not be_ordinal
      end
      
      it 'returns false if the form attribute is set to a value other than :ordinal' do
        Style::Number.new(:form => 'long-ordinal').should_not be_ordinal
      end
      
      it 'returns false if the form attribute is set to :ordinal' do
        Style::Number.new(:form => 'ordinal').should be_ordinal
        Style::Number.new(:form => :ordinal).should be_ordinal
      end
    end

    describe '#long_ordinal?' do
      it 'returns false by default' do
        Style::Number.new.should_not be_long_ordinal
      end
      
      it 'returns false if the form attribute is set to a value other than :"long-ordinal"' do
        Style::Number.new(:form => 'ordinal').should_not be_long_ordinal
      end
      
      it 'returns false if the form attribute is set to :ordinal' do
        Style::Number.new(:form => 'long-ordinal').should be_long_ordinal
      end
    end

    
    describe '#to_xml' do
      it 'returns an empty number tag by default' do
        Style::Number.new.to_xml.should == '<number/>'
      end
      
      it 'returns a tag with a all attribute assignments' do
        Style::Number.new(:form => 'roman').to_xml.should == '<number form="roman"/>'
      end
    end
    
  end
end