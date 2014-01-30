module CSL
  class Style

    class Sort < Node

      attr_children :key
      alias_child :sort_keys, :key

      def initialize(attributes = {})
        super(attributes)
        children[:key] = []

        yield self if block_given?
      end

      class Key < Node

        attr_struct :variable, :macro, :sort,
          :'names-use-min', :'names-use-first', :'names-use-last'

        attr_defaults :sort => 'ascending'

        has_no_children

        def name_options
          options = {}

          options[:'et-al-use-min'] = options[:'et-al-subsequent-use-min'] =
            attributes[:'names-use-min'] if attribute? :'names-use-min'

          options[:'et-al-use-first'] = options[:'et-al-subsequent-use-first'] =
            attributes[:'names-use-first'] if attribute? :'names-use-first'

          options[:'et-al-use-last'] = options[:'et-al-subsequent-use-last'] =
            attributes[:'names-use-last'] if attribute? :'names-use-last'

          options
        end

        def ascending?
          attributes[:sort] =~ /^ascending$/i
        end

        def ascending!
          attributes[:sort] = 'ascending'
        end

        def descending?
          !ascending?
        end

        def descending!
          attributes[:sort] = 'descending'
        end

        def macro?
          attribute? :macro
        end

        def macro
          fail 'cannot resolve macro: not associated with style' unless
            !root? && root.respond_to?(:macros)

          root.macros[attributes[:macro].to_s]
        end

        def variable
          attributes[:variable]
        end

      end

    end

  end
end
