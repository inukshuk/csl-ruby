require 'spec_helper'

module CSL
  
  describe Info do
    
    it { should_not be_nil }
    it { should_not have_children }
    
    describe '#nodename' do
      it 'returns "info"' do
        subject.nodename.should == 'info'
      end
    end
    
    describe '#children' do
      it 'returns a Info::Children instance' do
        Info.new.children.should be_a(Info::Children)
      end
      
      it 'allows to set the id by writer method' do
        lambda { Info.new.children.id = 'foo' }.should_not raise_error
      end

      it 'allows to set the id by array accessor' do
        lambda { Info.new.children[:id] = 'foo' }.should_not raise_error
      end
    end

    describe '#id' do
      it 'returns nil by default' do
        Info.new.id.should be nil
      end
    end
    
    describe '#to_xml' do
      it 'returns an empty info element by default' do
        subject.to_xml.should == '<info/>'
      end
      
      it 'prints the id if present' do
        Info.new { |i| i.id = 'apa' }.to_xml.should == '<info><id>apa</id></info>'
      end
      
    end
    
  end
  
  describe Info::Author do
    it { should_not be_nil }

    let(:poe) {
      Info::Author.new { |a|
        a.email = 'poe@baltimore.com'
        a.name = 'E. A. Poe'
      }
    }

    describe '#name' do
      it 'returns nil by default' do
        subject.name.should be nil
      end
      
      it 'returns the name if set' do
        poe.name.to_s.should == 'E. A. Poe'
      end      
    end

    describe '#email' do
      it 'returns the email' do
        poe.email.to_s.should == 'poe@baltimore.com'
      end
    end
    
    describe '#to_xml' do
      it 'returns an empty author by default' do
        subject.to_xml.should == '<author/>'
      end
            
      it 'prints all children' do
        poe.to_xml.should == '<author><name>E. A. Poe</name><email>poe@baltimore.com</email></author>'
      end      
    end
    
  end
  
  describe Info::Contributor do
    
    it { should_not be_nil }
    
    let(:bruce) { Info::Contributor.new { |c| c.name = "Bruce D'Arcus" } }
    
    describe '#name' do
      it 'returns the name' do
        bruce.name.to_s.should == "Bruce D'Arcus"
      end
    end
    
    
    describe '#to_xml' do
      it 'returns an empty contributor by default' do
        subject.to_xml.should == '<contributor/>'
      end
      
      it 'prints the name tag if present' do
        bruce.to_xml.should == "<contributor><name>Bruce D'Arcus</name></contributor>"
      end      
    end
    
  end
  
end