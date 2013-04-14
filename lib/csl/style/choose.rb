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
          attributes_for(*Schema.attr(:conditionals)).map do |name, values|
            extract_type_and_matcher_from(name) << values.to_s.split(/\s+/)
          end
        end

        def matcher(match = attributes[:match])
          case match
          when 'any'
            :any?
          when 'none'
            :none?
          else
            :all?
          end
        end

        private

        def extract_type_and_matcher_from(attribute)
          type, match = attribute.to_s.split(/-(any|all|none)$/, 2)

          # subtle: if the default matcher is :none? and there
          # is no override we to use :any? in the nested lists
          # to avoid double negation during evaluation

          if match.nil?
            match = matcher
            [type.to_sym, match == :none? ? :any? : matcher]
          else
            [type.to_sym, matcher(match)]
          end
        end
      end
    end

  end
end