require 'spec_helper'

module CSL
  
  describe Info do
    
    it { should_not be_nil }
    it { should_not have_children }
    
    let(:info) { Info.new }
    
    describe '#nodename' do
      it 'returns "info"' do
        subject.nodename.should == 'info'
      end
    end
    
    describe '#children' do
      it 'returns a Info::Children instance' do
        Info.new.children.should be_a(Info::Children)
      end
      
      it 'allows to set the id by array accessor' do
        lambda { Info.new.children[:id] = 'foo' }.should_not raise_error
      end
    end

    describe '#category' do
      it 'returns nil by default' do
        Info.new.category.should be_nil
      end
    end

    describe 'link accessors' do
      it { should_not have_self_link }
      it { should_not have_documentation_link }
      it { should_not have_template_link }
      
      it 'self_link is nil by default' do
        Info.new.self_link.should be_nil
      end

      it 'returns nil if no suitable link is set' do
        Info.new {|i| i.link = {:href => 'foo', :rel => 'documentation'} }.self_link.should be_nil
      end
      
      it 'returns the href value of the link if it is set' do
        Info.new {|i| i.link = {:href => 'foo', :rel => 'self'} }.self_link.should == 'foo'
      end
      
      it 'setter changes the value of existing link' do
        info = Info.new {|i| i.link = {:href => 'foo', :rel => 'self'} }
        expect { info.self_link = 'bar' }.to change { info.self_link }.from('foo').to('bar')
      end

      it 'setter creates new link node if link did not exist' do
        expect { info.self_link = 'bar' }.to change { info.has_self_link? }
        info.links[0].should be_a(Info::Link)
      end
      
    end
    
    describe '#to_xml' do
      it 'returns an empty info element by default' do
        subject.to_xml.should == '<info/>'
      end
      
      it 'prints the id if present' do
        Info.new { |i| i.set_child_id 'apa' }.to_xml.should == '<info><id>apa</id></info>'
      end

      it 'prints the category if present' do
        Info.new { |i| i.category = {:'citation-format' => 'author'} }.to_xml.should == '<info><category citation-format="author"/></info>'
      end
    end
    
    describe '#pretty_print' do
      it 'returns an empty info element by default' do
        subject.pretty_print.should == '<info/>'
      end

      it 'prints the id indented if present' do
        Info.new { |i| i.set_child_id 'apa' }.pretty_print.should == "<info>\n  <id>apa</id>\n</info>"
      end
    end
    
    describe '#tags' do
      it 'returns a list with an empty info element by default' do
        subject.tags.should == ['<info/>']
      end
      
      it 'returns a nested list if id is present' do
        Info.new { |i| i.set_child_id 'apa' }.tags.should == ['<info>', ['<id>apa</id>'], '</info>']
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