require 'spec_helper'

module CSL

  describe Parser do

    describe '.instance' do
      it 'returns the parser' do
        expect(Parser.instance).to be_instance_of(Parser)
      end
    end

    Parser.engines.each_pair do |name, parser|
      describe "when using the #{name} parser " do
        before(:all) { Parser.instance.parser = parser }

        describe '#parse' do

          describe 'for <foo/>' do
            let(:source) { '<foo/>' }

            it 'returns a CSL::Node' do
              expect(Parser.instance.parse(source)).to be_a(Node)
            end

            it 'returns a node with nodename "foo"' do
              expect(Parser.instance.parse(source).nodename).to eq('foo')
            end

            it 'returns a node with no attributes' do
              expect(Parser.instance.parse(source).attributes).to be_empty
            end

            it 'returns a node with no children' do
              expect(Parser.instance.parse(source)).not_to have_children
            end
          end

          describe 'for an empty name node' do
            ['<name/>', '<name></name>', '<name> </name>'].each do |source|
              it "returns a Style::Name for #{source.inspect} by default" do
                expect(Parser.instance.parse!(source)).to be_a(Style::Name)
              end

              it "returns a Style::Name for #{source.inspect} for Style scope" do
                expect(Parser.instance.parse!(source, Style)).to be_a(Style::Name)
              end

              it "returns a Node for #{source.inspect} for Locale scope" do
                expect(Parser.instance.parse!(source, Locale)).to be_a(Node)
              end

              it "returns an Info::Name for #{source.inspect} for Info scope" do
                expect(Parser.instance.parse!(source, Info)).to be_a(Info::Name)
              end
            end
          end

          describe 'for <foo bar="x"/>' do
            let(:src) { '<foo bar="x"/>' }

            it 'returns a node with attributes' do
              expect(Parser.instance.parse(src).attributes).not_to be_empty
            end

            it 'returns a node with attribute bar' do
              expect(Parser.instance.parse(src).attribute?(:bar)).to be
            end

            it 'bar should be "x"' do
              expect(Parser.instance.parse(src)[:bar]).to eq('x')
            end
          end

          describe 'for <foo>Foo Bar</foo>' do
            let(:src) { '<foo>Foo Bar</foo>' }

            it 'returns text node' do
              expect(Parser.instance.parse(src)).to be_textnode
            end
          end

          it 'returns a regular node for <x>\n <y/></x>' do
            expect(Parser.instance.parse("<x>\n <y/></x>")).not_to be_textnode
          end

          describe 'xml comments' do
            it 'ignores comment-only documents' do
              expect(Parser.instance.parse("<!--x></x-->")).to be_nil
            end

            it 'ignores comments in normal nodes' do
              expect(Parser.instance.parse("<x><!-- comment --></x>")).not_to have_children
            end

            it 'ignores comments in text nodes' do
              node = Parser.instance.parse("<x>foo<!-- comment --></x>")
              expect(node).to be_textnode
              expect(node).not_to have_children
              expect(node.text).to eq('foo')
            end

          end

        end

      end
    end

  end

end
