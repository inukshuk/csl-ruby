require 'spec_helper'

module CSL
  class Style

    describe Choose do

    end

    describe Choose::Block do
      
      describe '#conditions' do
        it 'returns an empty list by default' do
          expect(Choose::Block.new.conditions).to be_empty
        end
        
        describe 'when the node has a single condition' do
          let(:node) { Choose::Block.new(:'is-numeric' => 'edition' )}
          
          it 'returns an array with an array containing the type, matcher and values of the condition' do
            expect(node.conditions).to eq([[:'is-numeric', :all?, ['edition']]])
          end

          describe 'when the condition has multiple values' do
            before { node[:'is-numeric'] << ' issue' }
            
            it 'it splits the values in the conditions list' do
              expect(node.conditions).to eq([[:'is-numeric', :all?, ['edition', 'issue']]])
            end
          end
          
          describe 'when the node has two conditions' do
            before { node[:disambiguate] = 'true' }
            
            it 'returns an array with two elements' do
              expect(node.conditions.size).to eq(2)
            end
            
            it 'returns both conditions as arrays' do
              expect(node.conditions.map(&:first).sort).to eq([:disambiguate, :'is-numeric'])
              expect(node.conditions.map(&:last).sort).to eq([['edition'], ['true']])
            end
          end
        end
        
        describe 'when the node has a condition with a match override' do
          let(:node) { Choose::Block.new(:'variable-any' => 'author editor' )}
          
          it 'strips the match override from the type name and inserts it as the matcher' do
            expect(node.conditions).to eq([[:variable, :any?, ['author', 'editor']]])
          end
          
          describe 'other conditions' do
            before { node[:position] = 'false' }
            
            it 'are not affected by the override' do
              expect(node.conditions.map { |c| c[1].to_s }.sort).to eq(%w{ all? any? })
            end
          end
        end
      end
      
    end
  
  end
end