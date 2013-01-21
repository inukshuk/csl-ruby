module CSL
  class Style

    class Choose < Node

      class Block < Node
        attr_struct :match, *Schema.attr(:conditionals)

        attr_defaults :match => 'all'

        class << self
          def matches?(nodename)
            nodename.to_s =~ /^if(-else)?|else$/
          end
        end
        
        def conditions
          attributes_for(*Schema.attr(:conditionals)).map { |type, values|
            values.to_s.split(/\s+/).map { |value| [type, value] }
          }.flatten(1)
        end

        def matcher
          case attributes[:match]
          when 'any'
            :any?
          when 'none'
            :none?
          else
            :all?
          end
        end 
      end
    end

  end
end