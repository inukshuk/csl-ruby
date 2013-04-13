require 'spec_helper'

module CSL
  describe Style do
    before do
      @style = Style.new
    end

    it 'has a 1.x version by default' do
      @style[:version].should match(/1\.\d+(\.\d+)?/)
    end

    describe '#to_xml' do
      it 'returns an empty style' do
        @style.to_xml.should match(/^<style[^>]*\/>/)
      end

      it 'supports round-trip for apa style' do
        apa = Style.load(:apa)
        apa.should be_a(Style)

        xml = apa.to_xml
        xml.should match(/^<style[^>]*>/)

        Style.parse(xml).should be_a(Style)
      end
    end

    describe '#children' do

      it { should_not have_info }
      it { should_not have_locale }
      it { should_not have_macro }
      it { should_not have_citation }
      it { should_not have_bibliography }

      describe 'when it has a title' do
        before { @style.title = 'foo' }

        it { @style.should have_info }

        it 'info.title is a text node' do
          @style.info.title.should be_a(TextNode)
        end

        it '#title returns the title as a string' do
          @style.title.should be_a(String)
        end
      end
    end

    describe '#id accessor' do
      it 'returns nil by default' do
        @style.id.should be_nil
      end

      it 'writer sets the id to the passed-in string' do
        expect { @style.id = 'foobar' }.to change { @style.id }.from(nil).to('foobar')
      end
    end

    describe 'independent and dependent styles' do
      it 'styles are independent by default' do
        @style.should be_independent
      end

      it 'styles do not have independent-parent links by default' do
        @style.should_not have_independent_parent_link
      end

      it 'when setting an independet-parent link a style becomes dependent' do
        expect { @style.independent_parent_link = 'foo' }.to change { @style.independent? }
      end
    end

    describe 'macros' do
      it 'has no macros by default' do
        @style.should_not have_macros
      end

      it 'raises a validation error when adding a macro without name' do
        expect { Style.new << Style::Macro.new }.to raise_error(ValidationError)
      end

      describe 'when it has an "author" macro' do
        before { @style << Style::Macro.new(:name => 'author') }

        it 'has macros' do
          @style.should have_macros
        end

        it 'the macro is registered in the macros hash' do
          @style.macros.should have_key('author')
          @style.macros['author'].should be_a(Style::Macro)
        end

        it 'raises a validation error when adding a macro with a duplicate name' do
          expect { @style << Style::Macro.new(:name => 'author') }.to raise_error(ValidationError)
        end

        it 'unregisters the macro when it is deleted' do
          expect { @style.delete @style.macros['author'] }.to change { @style.macros.length }
        end
      end
    end
  end
end
