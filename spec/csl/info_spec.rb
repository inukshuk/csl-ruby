require 'spec_helper'

module CSL

  describe Info do

    it { is_expected.not_to be_nil }
    it { is_expected.not_to have_children }

    before { @info = Info.new }

    describe '#nodename' do
      it 'returns "info"' do
        expect(subject.nodename).to eq('info')
      end
    end

    describe 'license' do
      it { is_expected.not_to have_rights }
      it { is_expected.not_to be_default_license }

      it 'has no license by default' do
        expect(@info.license).to be_nil
      end

      it 'setting a license adds a rights node' do
        expect { @info.license = 'cc' }.to change { @info.has_rights? }
      end

      it 'setting the default license creates the default rights node' do
        @info.default_license!
        expect(@info).to have_rights
        expect(@info).to be_default_license

        @info.rights.text = 'cc'
        expect(@info).not_to be_default_license

        @info.default_license!
        expect(@info).to be_default_license
      end
    end

    describe '#children' do
      it 'returns a Info::Children instance' do
        expect(@info.children).to be_a(Info::Children)
      end

      it 'allows to set the id by array accessor' do
        expect { Info.new.children[:id] = 'foo' }.not_to raise_error
      end
    end

    describe '#category' do
      it 'returns an empty list by default' do
        expect(@info.category).to be_empty
      end
    end

    describe 'citation-format' do
      it 'has no citation-format by default' do
        expect(@info.citation_format).to be_nil
      end

      it 'setting a citation-format creates a new category node' do
        expect { @info.citation_format = 'foo' }.to change { @info.has_categories? }
      end

      it 'setting a citation-format actually sets the citation-format' do
        expect { @info.citation_format = 'bar' }.to change { @info.citation_format }.to(:bar)
      end

      describe 'given a category node with the citation-attribute set' do
        before { @info.add_child Info::Category.new(:'citation-format' => 'author') }

        it 'has a citation format' do
          expect(@info.citation_format).to eq(:author)
        end

        it 'setting a citation-format does not create a new category node' do
          expect { @info.citation_format = 'foo' }.not_to change { @info.categories.length }
        end

        it 'setting a citation-format actually sets the citation-format' do
          expect { @info.citation_format = 'bar' }.to change { @info.citation_format }.to(:bar)
        end
      end

      describe 'given a category node without the citation-attribute set' do
        before { @info.add_child Info::Category.new(:field => 'literature') }

        it 'has no citation-format by default' do
          expect(@info.citation_format).to be_nil
        end

        it 'setting a citation-format creates a new category node' do
          expect { @info.citation_format = 'foo' }.to change { @info.categories.length }.from(1).to(2)
        end

        it 'setting a citation-format actually sets the citation-format' do
          expect { @info.citation_format = 'bar' }.to change { @info.citation_format }.to(:bar)
        end
      end
    end

    describe 'link accessors' do
      it { is_expected.not_to have_self_link }
      it { is_expected.not_to have_documentation_link }
      it { is_expected.not_to have_template_link }

      it 'self_link is nil by default' do
        expect(@info.self_link).to be_nil
      end

      it 'returns nil if no suitable link is set' do
        expect(Info.new {|i| i.link = {:href => 'foo', :rel => 'documentation'} }.self_link).to be_nil
      end

      it 'returns the href value of the link if it is set' do
        expect(Info.new {|i| i.link = {:href => 'foo', :rel => 'self'} }.self_link).to eq('foo')
      end

      it 'setter changes the value of existing link' do
        info = Info.new {|i| i.link = {:href => 'foo', :rel => 'self'} }
        expect { info.self_link = 'bar' }.to change { info.self_link }.from('foo').to('bar')
      end

      it 'setter creates new link node if link did not exist' do
        expect { @info.self_link = 'bar' }.to change { @info.has_self_link? }
        expect(@info.links[0]).to be_a(Info::Link)
      end

    end

    describe '#to_xml' do
      it 'returns an empty info element by default' do
        expect(subject.to_xml).to eq('<info/>')
      end

      it 'prints the id if present' do
        expect(Info.new { |i| i.set_child_id 'apa' }.to_xml).to eq('<info><id>apa</id></info>')
      end

      it 'prints the category if present' do
        expect(Info.new { |i| i.category = {:'citation-format' => 'author'} }.to_xml).to eq('<info><category citation-format="author"/></info>')
      end
    end

    describe '#dup' do
      it 'does not copy ancestors' do
        apa = Style.load(:apa).info
        expect(apa).to be_a(Info)

        expect(apa).not_to be_root
        expect(apa.dup).to be_root
      end
    end

    describe '#deep_copy' do
      it 'copies the full sub-tree' do
        apa = Style.load(:apa).info
        expect(apa).to be_a(Info)

        xml = apa.to_xml

        copy = apa.deep_copy

        expect(apa.to_xml).to eq(xml) # original unchanged!
        expect(copy.to_xml).to eq(xml)
      end
    end

    describe '#pretty_print' do
      it 'returns an empty info element by default' do
        expect(subject.pretty_print).to eq('<info/>')
      end

      it 'prints the id indented if present' do
        expect(Info.new { |i| i.set_child_id 'apa' }.pretty_print).to eq("<info>\n  <id>apa</id>\n</info>")
      end
    end

    describe '#tags' do
      it 'returns a list with an empty info element by default' do
        expect(subject.tags).to eq(['<info/>'])
      end

      it 'returns a nested list if id is present' do
        expect(Info.new { |i| i.set_child_id 'apa' }.tags).to eq(['<info>', ['<id>apa</id>'], '</info>'])
      end

    end
  end

  describe Info::Author do
    it { is_expected.not_to be_nil }

    let(:poe) {
      Info::Author.new { |a|
        a.name = 'E. A. Poe'
        a.email = 'poe@baltimore.com'
      }
    }

    describe '#name' do
      it 'returns nil by default' do
        expect(subject.name).to be nil
      end

      it 'returns the name if set' do
        expect(poe.name.to_s).to eq('E. A. Poe')
      end
    end

    describe '#family' do
      it "returns the author's family name" do
        expect(poe.family).to eq('Poe')
      end
    end

    describe '#email' do
      it 'returns the email' do
        expect(poe.email.to_s).to eq('poe@baltimore.com')
      end
    end

    describe '#to_xml' do
      it 'returns an empty author by default' do
        expect(subject.to_xml).to eq('<author/>')
      end

      it 'prints all children' do
        expect(poe.to_xml).to eq('<author><name>E. A. Poe</name><email>poe@baltimore.com</email></author>')
      end
    end

  end

  describe Info::Contributor do

    it { is_expected.not_to be_nil }

    let(:bruce) { Info::Contributor.new { |c| c.name = "Bruce D'Arcus" } }

    describe '#name' do
      it 'returns the name' do
        expect(bruce.name.to_s).to eq("Bruce D'Arcus")
      end
    end


    describe '#to_xml' do
      it 'returns an empty contributor by default' do
        expect(subject.to_xml).to eq('<contributor/>')
      end

      it 'prints the name tag if present' do
        expect(bruce.to_xml).to eq("<contributor><name>Bruce D'Arcus</name></contributor>")
      end
    end

  end

  describe Info::Rights do
    it { is_expected.not_to be_nil }

    describe '#dup' do
      it 'copies attributes and text' do
        r = Info::Rights.new('foo')
        r[:license] = 'bar'

        c = r.dup
        expect(c.text).to eq('foo')
        expect(c[:license]).to eq('bar')
      end
    end
  end

end
