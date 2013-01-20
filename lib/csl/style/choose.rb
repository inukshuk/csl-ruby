module CSL
  class Style

    class Choose < Node

      class Block < Node
        attr_struct :match, :disambiguate, :'is-numeric', :'is-uncertain-date',
          :locator, :position, :type, :variable

        attr_defaults :match => 'all'

        class << self
          def matches?(nodename)
            nodename.to_s =~ /^if(-else)?|else$/
          end
        end
      end
    end

  end
end