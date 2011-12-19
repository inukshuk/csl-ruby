require 'spec_helper'

module CSL
  
  describe Parser do

    describe '.instance' do
      it 'returns the parser' do
        Parser.instance.should be_instance_of(Parser)
      end
    end

    Parser.engines.each_pair do |name, parser|
      describe "when using the #{name} parser " do
        before(:all) { Parser.instance.parser = parser }
    
        describe '#parse' do

          describe 'for <foo/>' do
            let(:source) { '<foo/>' }

            it 'returns a CSL::Node' do
              Parser.instance.parse(source).should be_a(Node)
            end

            it 'returns a node with nodename "foo"' do
              Parser.instance.parse(source).nodename.should == 'foo'
            end

            it 'returns a node with no attributes' do
              Parser.instance.parse(source).should_not have_attributes
            end

            it 'returns a node with no children' do
              Parser.instance.parse(source).should_not have_children
            end
          end

          describe 'for <foo bar="x"/>' do
            let(:source) { '<foo bar="x"/>' }
            
            it 'returns a node with attributes' do
              Parser.instance.parse(source).should have_attributes
            end

            it 'returns a node with attribute bar' do
              Parser.instance.parse(source).attribute?(:bar).should be
            end

            it 'bar should be "x"' do
              Parser.instance.parse(source)[:bar].should == 'x'
            end
          end

          describe 'for <foo>Foo Bar</foo>' do
            let(:source) { '<foo>Foo Bar</foo>' }
            
            it 'returns text node' do
              Parser.instance.parse(source).should be_textnode
            end
          end

          it 'returns a regular node for <x>\n <y/></x>' do
            Parser.instance.parse("<x>\n <y/></x>").should_not be_textnode
          end
          
        end
        
      end
    end

  end
  
end