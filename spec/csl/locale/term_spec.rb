# coding: utf-8
require 'spec_helper'

module CSL
  describe Locale::Terms do

    it { is_expected.not_to be nil }

    describe '#to_xml' do
      it 'returns <terms/> by default' do
        expect(subject.to_xml).to eq('<terms/>')
      end
    end

    describe '.specialize' do
      it 'filters the passed in hash to contain only match-able entries' do
        expect(Locale::Term.specialize({ :form => 'short', :foo => 'bar' })).to eq({ :form => 'short' })
      end
    end

    describe '#ordinalize' do

      describe "given standard English terms" do
        let(:en) do
          Locale::Terms.parse <<-EOS
          <terms>
            <term name="ordinal">th</term>
            <term name="ordinal-01">st</term>
            <term name="ordinal-02">nd</term>
            <term name="ordinal-03">rd</term>
            <term name="ordinal-11">th</term>
            <term name="ordinal-12">th</term>
            <term name="ordinal-13">th</term>
          </terms>
          EOS
        end

        %w{
          ordinal ordinal-01 ordinal-02 ordinal-03 ordinal
        }.each_with_index do |ordinal, number|
          it "returns #{ordinal.inspect} for #{number}" do
            expect(en.ordinalize(number)[:name]).to eq(ordinal)
          end
        end
      end

    end

    describe '#lookup' do

      describe "given standard English terms" do
        let(:en) do
          Locale::Terms.parse <<-EOS
          <terms>
            <term name="page" form="short">
              <single>p.</single>
              <multiple>pp.</multiple>
            </term>
            <term name="page">
              <single>page</single>
              <multiple>pages</multiple>
            </term>
            <term name="section">
              <single>section</single>
              <multiple>sections</multiple>
            </term>
            <term name="section" form="short">sec.</term>
            <term name="section" form="symbol">
              <single>§</single>
              <multiple>§§</multiple>
            </term>
            <term name="editor">
              <single>editor</single>
              <multiple>editors</multiple>
            </term>
            <term name="editor" form="short">
              <single>ed.</single>
              <multiple>eds.</multiple>
            </term>
            <term name="editor" form="verb">edited by</term>
            <term name="editor" form="verb-short">ed.</term>
          </terms>
          EOS
        end

        it 'returns nil if there is no matching term' do
          expect(en.lookup(:foo)).to be_nil
        end

        it 'returns the long form by default' do
          expect(en.lookup(:page)).to be_long
        end

        it 'returns the term in the passed-in form if available' do
          expect(en.lookup(:section, :form => 'long')).to be_long
          expect(en.lookup(:section, :form => 'short')).to be_short
          expect(en.lookup(:section, :form => 'symbol')).to be_symbol

          expect(en.lookup(:editor)).to be_long
          expect(en.lookup(:editor, :form => 'long')).to be_long
          expect(en.lookup(:editor, :form => 'verb')).to be_verb
          expect(en.lookup(:editor, :form => 'verb-short')).to be_verb_short
        end

        it 'returns the right fallback form if the passed-in form is not available' do
          expect(en.lookup(:page, :form => 'verb')).to be_long
          expect(en.lookup(:page, :form => 'verb-short')).to be_long
          expect(en.lookup(:page, :form => 'symbol')).to be_short
        end

        it 'ignores irrelevant options' do
          expect(en.lookup(:page, :plural => true)).not_to be_nil
        end
      end

    end
  end

  describe Locale::Term do

    it { is_expected.not_to be_nil }

    it { is_expected.not_to be_gendered }
    it { is_expected.to be_neutral }

    it { is_expected.to be_long }

    it { is_expected.not_to be_ordinal }
    it { is_expected.not_to be_short_ordinal }
    it { is_expected.not_to be_long_ordinal }

    it 'is not a textnode by default' do
      expect(subject).not_to be_textnode
    end

    it 'is a textnode when the text is "foo"' do
      expect(Locale::Term.new { |t| t.text = 'foo' }).to be_textnode
    end

    describe 'gender attribute is set' do
      let(:m) { Locale::Term.new(:name => 'month-05') { |t| t.masculine!; t.text = 'Mai' } }
      let(:f) { Locale::Term.new(:name => 'edition') { |t| t.feminine!; t.text = 'Ausgabe' } }

      it 'is gendered' do
        expect(m).to be_gendered
        expect(f).to be_gendered
      end

      it 'is feminine or masculine' do
        expect(m).to be_masculine
        expect(f).to be_feminine
      end

      it 'is not neutral' do
        expect(m).not_to be_neutral
        expect(f).not_to be_neutral
      end

      describe '#to_xml' do
        it 'contains the correct gender' do
          expect(m.to_xml).to match(/gender="masculine"/)
          expect(f.to_xml).to match(/gender="feminine"/)
        end
      end

      describe '#match?' do
        it 'matches the name when passed a string' do
          expect(m).to be_match(:name => 'month-05')
        end

        it 'matches the name when passed a pattern' do
          expect(m).to be_match(:name => /month-\d\d/)
        end

        it 'matches when passed a matching hash without gender' do
          expect(f).to be_match(:name => 'edition')
        end

        it 'does not match when passed a matching hash with wrong gender' do
          expect(f.matches?(:name => 'edition', :gender => 'masculine')).not_to be_truthy
        end

        it 'matches when passed a matching hash with matching gender' do
          expect(f.matches?(:name => 'edition', :gender => 'feminine')).to be_truthy
        end
      end

      describe '#exact_match?' do
        it 'does not match when passed a matching hash without gender' do
          expect(f).not_to be_exact_match(:name => 'edition')
        end
      end

      describe 'attributes#to_a' do
        it 'returns an array of all attribute values of underlying struct' do
          expect(f.attributes.to_a).to eq(['edition', 'long', 'feminine', nil, nil])
        end
      end
    end

    describe '#to_s' do
      it 'returns an empty string by default' do
        expect(Locale::Term.new.to_s).to eq('')
      end

      describe 'given a simple term' do
        let(:node) { Locale::Term.new { |t| t.text = 'foo' } }

        it "returns the term's text" do
          expect(node.to_s).to eq(node.text)
        end
      end

      describe 'given a compound term' do
        let(:node) { Locale::Term.new { |t| t.single = 'shoe'; t.multiple = 'shoes' } }

        it "returns the term's singular form by default" do
          expect(node.to_s).to eq(node.singularize)
        end

        it "returns the term's plural form when passed :number => :plural" do
          expect(node.to_s(:number => :plural)).to eq(node.pluralize)
        end

        it "returns the term's plural form when passed :number => 2" do
          expect(node.to_s(:number => 2)).to eq(node.pluralize)
        end

        it "returns the term's singular form when passed :number => 1" do
          expect(node.to_s(:number => 1)).to eq(node.singularize)
        end

        it "returns the term's plural form when passed :plural => true" do
          expect(node.to_s(:plural => true)).to eq(node.pluralize)
        end

      end
    end

    describe '#to_xml' do
      it 'returns <term/> by default' do
        expect(subject.to_xml).to eq('<term/>')
      end

      it 'returns <term>foo</term> when the text is "foo"' do
        expect(Locale::Term.new { |t| t.text = 'foo' }.to_xml).to eq('<term>foo</term>')
      end

      it 'returns <term><multiple>foo</multiple></term> when multiple is "foo"' do
        expect(Locale::Term.new { |t| t.multiple = 'foo' }.to_xml).to eq('<term><multiple>foo</multiple></term>')
      end

    end
  end
end
