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
          
          it 'returns an array with an array containing the type, matcher and values of the condition' do
            node.conditions.should == [[:'is-numeric', :all?, ['edition']]]
          end

          describe 'when the condition has multiple values' do
            before { node[:'is-numeric'] << ' issue' }
            
            it 'it splits the values in the conditions list' do
              node.conditions.should == [[:'is-numeric', :all?, ['edition', 'issue']]]
            end
          end
          
          describe 'when the node has two conditions' do
            before { node[:disambiguate] = 'true' }
            
            it 'returns an array with two elements' do
              node.conditions.should have_exactly(2).items
            end
            
            it 'returns both conditions as arrays' do
              node.conditions.map(&:first).sort.should == [:disambiguate, :'is-numeric']
              node.conditions.map(&:last).sort.should == [['edition'], ['true']]
            end
          end
        end
        
        describe 'when the node has a condition with a match override' do
          let(:node) { Choose::Block.new(:'variable-any' => 'author editor' )}
          
          it 'strips the match override from the type name and inserts it as the matcher' do
            node.conditions.should == [[:variable, :any?, ['author', 'editor']]]
          end
          
          describe 'other conditions' do
            before { node[:position] = 'false' }
            
            it 'are not affected by the override' do
              node.conditions.map { |c| c[1].to_s }.sort.should == %w{ all? any? }
            end
          end
        end
      end
      
    end
  
  end
end