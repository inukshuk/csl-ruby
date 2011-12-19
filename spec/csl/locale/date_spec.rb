require 'spec_helper'

module CSL

  describe Locale::Date do
  
    let(:date) { Locale::Date.new }
    
    it { should_not be_nil }
    
    it { should_not be_text }
    it { should_not be_numeric }
  
    describe '#parts' do
      
      it 'returns nil by default' do
        date.parts.should be_empty
      end
      
    end
    
    describe '#to_xml' do
      
      it 'returns <date/> by default' do
        Locale::Date.new.to_xml.should == '<date/>'
      end

      it 'returns <date form="numeric"/> for an empty numeric date' do
        Locale::Date.new(:form => 'numeric').to_xml.should == '<date form="numeric"/>'
      end
      
    end
    
  end

  describe Locale::DatePart do

    it { should_not be_nil }
    
    it { should_not be_day }
    it { should_not be_month }
    it { should_not be_year }
  
    describe '#to_xml' do
      
      it 'returns <date-part/> by default' do
        Locale::DatePart.new.to_xml.should == "<date-part/>"
      end
      
      it 'returns <date-part name="year"/> when the name is "year"' do
        Locale::DatePart.new(:name => 'year').to_xml.should == '<date-part name="year"/>'
      end
      
      it 'returns <date-part name="month" form="numeric" prefix="-"/> for a numeric month with prefix "-"' do
        Locale::DatePart.new(:name => 'month', :form => 'numeric', :prefix => '-').to_xml.should match(/(\s(name|form|prefix)="[^"]+"){3}/)
      end
      
    end
    
  end


end