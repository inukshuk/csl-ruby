require 'spec_helper'

module CSL
	describe 'Treelike' do
  
	  before(:all) do 
			class TestTree; include Treelike; end
		end
  
	  let(:node) { TestTree.new }
    
    let(:lvl1) { TestTree.new.add_child(TestTree.new) }
    let(:lvl2) { TestTree.new.add_child(TestTree.new).add_child(TestTree.new) }

    it 'has no children by default' do
      node.should_not have_children
    end
    
    describe '#children' do
      
      it 'is empty by default' do
        node.children.should be_empty
      end
      
      it 'grows when adding child nodes' do
        expect { node << TestTree.new }.to change { node.children.length }.by(1)
      end
      
    end
    
	  describe '#nodename' do
	    it 'returns the class name in attribute form by default' do
	      node.nodename.should == 'test-tree'
	    end
	  end
    
	  describe '#ancestors' do
      it 'returns and empty list by default' do
        node.ancestors.should be_empty
      end

      it 'returns a list with one ancestor at level 1' do
        lvl1.ancestors.should have(1).element
      end
        
      it 'the last ancestor is also the root node at levels 1 and deeper' do
        lvl1.ancestors.last.should be_root
        lvl2.ancestors.last.should be_root
      end

      it 'returns a list with two ancestors at level 2' do
        lvl2.ancestors.should have(2).elements
      end      
	  end

    it 'is a root node by default' do
      node.should be_root
    end
    
	  describe '#root' do  
	    it 'returns self at level 0' do
	      node.root.should equal(node)
	    end

      it 'returns the parent at level 1' do
        lvl1.root.should == lvl1.parent
      end

      it 'returns parent.parent at level 2' do
        lvl2.root.should == lvl2.parent.parent
      end
	  end
    
    describe '#depth' do
      it 'returns 0 by default' do
        node.depth.should == 0
      end

      it 'returns 1 at level 1' do
        lvl1.depth.should == 1
      end

      it 'returns 2 at level 2' do
        lvl2.depth.should == 2
      end
      
      it 'grows when the node is added to another node' do
        expect { TestTree.new << node }.to change { node.depth }.by(1)
      end
      
    end
    
	end
	
end