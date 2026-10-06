require 'spec_helper'

module CSL
	describe 'Treelike' do
  
	  before(:all) do 
			class TestTree
			  include Treelike
			  
			  def initialize
			    @children = self.class.create_children
			  end
			end
		end
  
	  let(:node) { TestTree.new }
    
    let(:lvl1) { TestTree.new.add_child(TestTree.new) }
    let(:lvl2) { TestTree.new.add_child(TestTree.new).add_child(TestTree.new) }

    it 'has no children by default' do
      expect(node).not_to have_children
    end
    
    it 'is empty by default' do
      expect(node).to be_empty
    end
    
    describe '#children' do
      
      it 'is empty by default' do
        expect(node.children).to be_empty
      end
      
      it 'grows when adding child nodes' do
        expect { node << TestTree.new }.to change { node.children.length }.by(1)
      end
      
    end
    
	  describe '#nodename' do
	    it 'returns the class name in attribute form by default' do
	      expect(node.nodename).to eq('test-tree')
	    end
	  end
    
	  describe '#ancestors' do
      it 'returns and empty list by default' do
        expect(node.ancestors).to be_empty
      end

      it 'returns a list with one ancestor at level 1' do
        expect(lvl1.ancestors.size).to eq(1)
      end
        
      it 'the last ancestor is also the root node at levels 1 and deeper' do
        expect(lvl1.ancestors.last).to be_root
        expect(lvl2.ancestors.last).to be_root
      end

      it 'returns a list with two ancestors at level 2' do
        expect(lvl2.ancestors.size).to eq(2)
      end      
	  end

    it 'is a root node by default' do
      expect(node).to be_root
    end
    
	  describe '#root' do  
	    it 'returns self at level 0' do
	      expect(node.root).to equal(node)
	    end

      it 'returns the parent at level 1' do
        expect(lvl1.root).to eq(lvl1.parent)
      end

      it 'returns parent.parent at level 2' do
        expect(lvl2.root).to eq(lvl2.parent.parent)
      end
	  end
    
    describe '#depth' do
      it 'returns 0 by default' do
        expect(node.depth).to eq(0)
      end

      it 'returns 1 at level 1' do
        expect(lvl1.depth).to eq(1)
      end

      it 'returns 2 at level 2' do
        expect(lvl2.depth).to eq(2)
      end
      
      it 'grows when the node is added to another node' do
        expect { TestTree.new << node }.to change { node.depth }.by(1)
      end
      
    end

    describe 'named children' do
      before(:all) do
        class TestTree
          attr_children :'test-tree'
        end
        class AnotherTree
          include Treelike
        end     
      end
    
      it 'the class contains a children struct' do
        expect(TestTree.const?(:Children)).to be true
      end
      
      describe '.create_children' do
        it 'returns the children struct' do
          expect(TestTree.create_children).to be_a(Struct)
        end
      end
      
      describe '#children' do
        it 'returns a children struct instance' do
          expect(TestTree.new.children).to be_a(Struct)
        end
      end
      
      it 'has no children by default' do
        expect(TestTree.new).not_to have_children
      end
      
      it 'has children when adding child nodes' do
        expect { node << TestTree.new }.to change { node.has_children? }.to(true)
      end

      it 'raises an error when adding a child with an invalid name' do
        expect { node << AnotherTree.new }.to raise_error(ValidationError)
      end 
    
      it 'accepts multiple nodes of the same name' do
        expect { node << TestTree.new << TestTree.new }.to change {
          node.children.each.to_a.length
        }.from(0).to(2)
      end
      
    end
    

    describe '#unlink' do
      it 'removes only the node itself from array children' do
        group = Style::Group.new
        a, b = Style::Text.new(:value => 'x'), Style::Text.new(:value => 'x')
        group << a << b

        a.unlink

        expect(group.children.length).to eq(1)
        expect(group.children[0]).to equal(b)
        expect(b.parent).to equal(group)
        expect(a.parent).to be_nil
      end

      it 'removes only the node itself from named children' do
        style = Style.new
        a, b = Locale.new('en'), Locale.new('en-US')
        style << a << b

        a.unlink

        expect(style.locales.length).to eq(1)
        expect(style.locales[0]).to equal(b)
        expect(a.parent).to be_nil
      end
    end

    describe '#delete_child' do
      it 'does not delete equal nodes which are not children' do
        group = Style::Group.new
        group << Style::Text.new(:value => 'x') << Style::Text.new(:value => 'x')

        expect(group.delete_child(Style::Text.new(:value => 'x'))).to be_nil
        expect(group.children.length).to eq(2)
      end

      it 'deletes only the passed-in child' do
        group = Style::Group.new
        a, b = Style::Text.new(:value => 'x'), Style::Text.new(:value => 'x')
        group << a << b

        expect(group.delete_child(b)).to equal(b)
        expect(group.children.length).to eq(1)
        expect(group.children[0]).to equal(a)
        expect(b.parent).to be_nil
      end

      it 'returns the deleted child of named children' do
        style = Style.new
        a, b = Locale.new('en'), Locale.new('de')
        style << a << b

        expect(style.delete_child(a)).to equal(a)
        expect(a.parent).to be_nil
        expect(style.locales).to eq([b])
      end
    end
	end
	
end