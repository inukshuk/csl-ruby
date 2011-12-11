require 'spec_helper'

module CSL
  describe Term::Value do
    it { should_not be_nil }
    
    it 'defaults to an empty string' do
      Term::Value.new.to_s.should == ''
    end
    
  end
  
  describe Term::Options do
    it { should_not be_nil }    
  end
  
  describe Term do

		let(:term) do
			t = Term.new('foobar')
			# t[{:form => 'long'}] = 
		end

    it { should_not be_nil }


		describe '#[]' do
			
		end
  end
end