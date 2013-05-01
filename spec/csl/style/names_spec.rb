require 'spec_helper'

module CSL
  describe Style::Names do

  end

  describe Style::Name do

    it { should be_delimiter_contextually_precedes_last }

    [:never, :always, :contextually].each do |setting|
      setter = "delimiter_#{setting}_precedes_last!"
      predicate = "delimiter_#{setting}_precedes_last?"

      describe "##{setter}" do
        it 'sets the delimiter precedes last option accordingly' do
          subject.send(setter).send(predicate).should == true
        end
      end
    end

  end

  describe Style::NamePart do

  end

  describe Style::EtAl do

  end

  describe Style::Substitute do

  end
end