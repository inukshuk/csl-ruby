require 'spec_helper'

module CSL
  class Style

    describe Choose do

    end

    describe Choose::Block do
      
      describe '#conditions' do
        it 'returns an empty list by default' do
          Choose::Block.new.conditions.should be_empty
        end
        
        describe 'when the node has a single condition' do
          let(:node) { Choose::Block.new(:'is-numeric' => 'edition' )}
          
          it 'returns an array with an array containing the type and value of the condition' do
            node.conditions.should == [[:'is-numeric', 'edition']]
          end
          
          describe 'when the node has two conditions' do
            before(:each) { node[:disambiguate] = 'true' }
            
            it 'returns an array with two elements' do
              node.conditions.should have_exactly(2).items
            end
            
            it 'returns both conditions as arrays' do
              node.conditions.map(&:first).sort.should == [:disambiguate, :'is-numeric']
              node.conditions.map(&:last).sort.should == ['edition', 'true']
            end
          end
        end
        
        describe 'when the node has a single condition with multiple values' do
          let(:node) { Choose::Block.new(:variable => 'author editor' )}
          
          it 'expands the conditions in the result' do
            node.conditions.should == [[:variable, 'author'], [:variable, 'editor']]
          end
        end
      end
      
    end
  
  end
end