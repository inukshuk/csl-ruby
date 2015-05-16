require 'spec_helper'

module CSL
  describe Style do
    let(:style) { Style.new }

    it 'has a 1.x version by default' do
      expect(style[:version]).to match(/1\.\d+(\.\d+)?/)
    end

    it 'has the default version' do
      expect(style.default_attribute?(:version)).to be_truthy
    end

    it 'has a the default namespace attribute' do
      expect(style[:xmlns]).to eq(CSL::Schema.namespace)
      expect(style.default_attribute?(:xmlns)).to be_truthy
    end

    describe '#to_xml' do
      it 'returns an empty style' do
        expect(style.to_xml).to match(/^<style[^>]*\/>/)
      end

      it 'includes the xml namespace' do
        expect(style.to_xml).to match(CSL::Schema.namespace)
      end

      it 'supports round-trip for apa style' do
        apa = Style.load(:apa)
        expect(apa).to be_a(Style)

        xml = apa.to_xml
        expect(xml).to match(/^<style[^>]*>/)

        expect(Style.parse(xml)).to be_a(Style)
      end
    end

    describe '#deep_copy' do
      it 'works on apa style' do
        apa = Style.load(:apa)
        expect(apa).to be_a(Style)

        xml = apa.to_xml

        copy = apa.deep_copy

        expect(apa.to_xml).to eq(xml) # original unchanged!
        expect(copy.to_xml).to eq(xml)
      end
    end

    describe '#children' do

      it { is_expected.not_to have_info }
      it { is_expected.not_to have_locale }
      it { is_expected.not_to have_macro }
      it { is_expected.not_to have_citation }
      it { is_expected.not_to have_bibliography }

      describe 'when it has a title' do
        before { style.title = 'foo' }

        it { expect(style).to have_info }

        it 'info.title is a text node' do
          expect(style.info.title).to be_a(TextNode)
        end

        it '#title returns the title as a string' do
          expect(style.title).to be_a(String)
        end
      end
    end

    describe '#id accessor' do
      it 'returns nil by default' do
        expect(style.id).to be_nil
      end

      it 'writer sets the id to the passed-in string' do
        expect { style.id = 'foobar' }.to change { style.id }.from(nil).to('foobar')
      end
    end

    describe 'independent and dependent styles' do
      it 'styles are independent by default' do
        expect(style).to be_independent
      end

      it 'styles do not have independent-parent links by default' do
        expect(style).not_to have_independent_parent_link
      end

      it 'when setting an independet-parent link a style becomes dependent' do
        expect { style.independent_parent_link = 'foo' }.to change { style.independent? }
      end

      it 'looks up independent styles parents locally first' do
        style.independent_parent_link = 'http://example.com/non-existent/styles/apa'
        expect(style.independent_parent).to eq Style.load('apa')
      end
    end

    describe 'macros' do
      it 'has no macros by default' do
        expect(style).not_to have_macros
      end

      it 'raises a validation error when adding a macro without name' do
        expect { Style.new << Style::Macro.new }.to raise_error(ValidationError)
      end

      describe 'when it has an "author" macro' do
        before { style << Style::Macro.new(:name => 'author') }

        it 'has macros' do
          expect(style).to have_macros
        end

        it 'the macro is registered in the macros hash' do
          expect(style.macros).to have_key('author')
          expect(style.macros['author']).to be_a(Style::Macro)
        end

        it 'raises a validation error when adding a macro with a duplicate name' do
          expect { style << Style::Macro.new(:name => 'author') }.to raise_error(ValidationError)
        end

        it 'unregisters the macro when it is deleted' do
          expect { style.delete style.macros['author'] }.to change { style.macros.length }
        end
      end
    end
  end
end
