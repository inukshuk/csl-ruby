require 'spec_helper'

module CSL
  describe Style::Date do
  
  end

  describe Style::DatePart do

    describe '#numeric-leading-zeros?' do
      
      it { should_not be_numeric_leading_zeros }
      
      it 'returns true when the form is set accordingly' do
        subject[:form] = 'numeric-leading-zeros'
        subject.should be_numeric_leading_zeros
      end
    end

  end
end