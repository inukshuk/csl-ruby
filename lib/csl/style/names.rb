# encoding: utf-8

module CSL
  class Style

    class Names < Node

      attr_struct :variable, *Schema.attr(:names, :delimiter, :affixes, :font)

      attr_children :name, :'et-al', :label, :substitute

      alias labels label

      def initialize(attributes = {})
        super(attributes)
        children[:label] = []

        yield self if block_given?
      end

      def delimiter
        attributes.fetch(:delimiter, '')
      end

      def has_variable?
        attribute?(:variable)
      end

      def variable
        attributes[:variable].to_s
      end

    end


    class Name < Node

      attr_struct :form, *Schema.attr(:name, :affixes, :font, :delimiter)

      attr_defaults :form => 'long', :delimiter => ', ',
        :'delimiter-precedes-last' => 'contextual', :initialize => true,
        :'sort-separator' => ', '

      attr_children :'name-part'

      alias parts name_part

      def initialize(attributes = {})
        super(attributes)
        children[:'name-part'] = []

        # TODO inherit from style, citation and bibliography

        yield self if block_given?
      end

      def name_options
        attributes_for :form, :initialize, :'initialize-with', :'sort-separator'
      end

      def initialize?
        attributes[:initialize].to_s !~ /^false$/i
      end

      def et_al
        parent && parent.et_al
      end

      # @param names [#to_i, Enumerable] the list of names (or its length)
      # @return [Boolean] whether or not the should be truncate
      def truncate?(names, subsequent = false)
        names = names.length if names.respond_to?(:length)
        limit = truncate_when(subsequent)

        !limit.zero? && names.to_i >= limit
      end

      # @param [Enumerable] names
      # @return [Array] the truncated list of names
      def truncate(names, subsequent = false)
        limit = truncate_at(subsequent)

        return names if limit.zero?
        names.take limit
      end

      def truncate_when(subsequent = false)
        if subsequent && attribute?(:'et-al-subsequent-min')
          attributes[:'et-al-subsequent-min'].to_i
        else
          attributes[:'et-al-min'].to_i
        end
      end

      def truncate_at(subsequent = false)
        if subsequent && attribute?(:'et-al-subsequent-use-first')
          attributes[:'et-al-subsequent-use-first'].to_i
        else
          attributes[:'et-al-use-first'].to_i
        end
      end

      def truncate_at!(at)
        attributes[:'et-al-use-first'] = at.to_i
        self
      end

      def truncate_when!(pos)
        attributes[:'et-al-min'] = pos.to_i
        self
      end

      def truncate_subsequent_at!(at)
        attributes[:'et-al-subsequent-use-first'] = at.to_i
        self
      end

      def truncate_subsequent_when!(pos)
        attributes[:'et-al-subsequent-min'] = pos.to_i
        self
      end

      # @return [String] the delimiter between family and given names
      #   in sort order
      def sort_separator
        attributes[:'sort-separator'].to_s
      end

      # @return [String] the delimiter between names
      def delimiter
        attributes[:delimiter].to_s
      end

      def name_as_sort_order?
        attribute?(:'name-as-sort-order')
      end

      def name_as_sort_order_at?(position)
        return false unless name_as_sort_order?
        all_names_as_sort_order? || position == 1 && first_name_as_sort_order?
      end

      def name_as_sort_order
        attributes[:'name-as-sort-order'].to_s
      end

      alias sort_order name_as_sort_order

      def first_name_as_sort_order?
        !!(attributes[:'name-as-sort-order'].to_s =~ /^first$/i)
      end

      def all_names_as_sort_order?
        !!(attributes[:'name-as-sort-order'].to_s =~ /^all$/i)
      end

      def first_name_as_sort_order!
        attributes[:'name-as-sort-order'] = 'first'
        self
      end

      def all_names_as_sort_order!
        attributes[:'name-as-sort-order'] = 'all'
        self
      end

      def delimiter_precedes_et_al?(names)
        names = names.length if names.respond_to?(:length)

        case
        when delimiter_never_precedes_et_al?
          false
        when delimiter_always_precedes_et_al?
          true
        when delimiter_precedes_et_al_after_inverted_name?
          name_as_sort_order_at?(names.to_i)
        else
          names.to_i > 1
        end
      end

      # @return [Boolean] whether or not the delimmiter should
      #   always be inserted before et-al
      def delimiter_always_precedes_et_al?
        !!(attributes[:'delimiter-precedes-et-al'].to_s =~ /^always$/i)
      end

      # Set the :'delimiter-precedes-et-al' attribute to 'always'.
      # @return [self] self
      def delimiter_always_precedes_et_al!
        attributes[:'delimiter-precedes-et-al'] = 'always'
        self
      end

      alias delimiter_precedes_et_al! delimiter_always_precedes_et_al!


      # @return [Boolean] whether or not the delimiter should
      #   never be inserted before et-al
      def delimiter_never_precedes_et_al?
        !!(attributes[:'delimiter-precedes-et-al'].to_s =~ /^never$/i)
      end

      # Set the :'delimiter-precedes-et-al' attribute to 'never'
      # @return [self] self
      def delimiter_never_precedes_et_al!
        attributes[:'delimiter-precedes-et-al'] = 'never'
        self
      end

      # @return [Boolean] whether or not the delimtier should
      #   be inserted between before et-al depending on the
      #   number of names rendered
      def delimiter_contextually_precedes_et_al?
        return true unless attribute?[:'delimiter-precedes-et-al']
        !!(attributes[:'delimiter-precedes-et-al'].to_s =~ /^contextual/i)
      end

      # Set the :'delimiter-precedes-et-al' attribute to 'contextual'
      # @return [self] self
      def delimiter_contextually_precedes_et_al!
        attributes[:'delimiter-precedes-et-al'] = 'contextual'
        self
      end

      def delimiter_precedes_et_al_after_inverted_name?
        !!(attributes[:'delimiter-precedes-et-al'].to_s =~ /^after-inverted-name/i)
      end

      def delimiter_precedes_et_al_after_inverted_name!
        attributes[:'delimiter-precedes-et-al'] = 'after-inverted-name'
        self
      end

      # @param names [#to_i, Enumerable] the list of names (or its length)
      # @return [Boolean] whether or not the delimiter will be inserted between
      #   the penultimate and the last name
      def delimiter_precedes_last?(names)
        names = names.length if names.respond_to?(:length)

        case
        when !attribute?(:and)
          true
        when delimiter_never_precedes_last?
          false
        when delimiter_always_precedes_last?
          true
        when delimiter_precedes_last_after_inverted_name?
          if name_as_sort_order?
            all_names_as_sort_order? || names.to_i == 2
          else
            false
          end

        else
          names.to_i > 2
        end
      end

      # @return [Boolean] whether or not the should always be inserted between
      #   the penultimate and the last name
      def delimiter_always_precedes_last?
        !!(attributes[:'delimiter-precedes-last'].to_s =~ /^always$/i)
      end

      # Set the :'delimiter-precedes-last' attribute to 'always'.
      # @return [self] self
      def delimiter_always_precedes_last!
        attributes[:'delimiter-precedes-last'] = 'always'
        self
      end

      alias delimiter_precedes_last! delimiter_always_precedes_last!


      # @return [Boolean] whether or not the should never be inserted between
      #   the penultimate and the last name
      def delimiter_never_precedes_last?
        !!(attributes[:'delimiter-precedes-last'].to_s =~ /^never$/i)
      end

      # Set the :'delimiter-precedes-last' attribute to 'never'
      # @return [self] self
      def delimiter_never_precedes_last!
        attributes[:'delimiter-precedes-last'] = 'never'
        self
      end

      # @return [Boolean] whether or not the should be inserted between the
      #   penultimate and the last name depending on the number of names
      def delimiter_contextually_precedes_last?
        !!(attributes[:'delimiter-precedes-last'].to_s =~ /^contextual/i)
      end

      # Set the :'delimiter-precedes-last' attribute to 'contextual'
      # @return [self] self
      def delimiter_contextually_precedes_last!
        attributes[:'delimiter-precedes-last'] = 'contextual'
        self
      end

      def delimiter_precedes_last_after_inverted_name?
        !!(attributes[:'delimiter-precedes-last'].to_s =~ /^after-inverted-name/i)
      end

      def delimiter_precedes_last_after_inverted_name!
        attributes[:'delimiter-precedes-last'] = 'after-inverted-name'
        self
      end

      def ellipsis?
        attributes[:'et-al-use-last'].to_s =~ /^true$/
      end

      def ellipsis
        "#{delimiter}… "
      end

      def connector
        c = attributes[:and]
        c == 'symbol' ? '&' : c
      end

      def connector=(c)
        attributes[:and] = c
      end
    end

    class NamePart < Node
      has_no_children
      attr_struct :name, :'text-case', *Schema.attr(:affixes, :font)

      def name
        attributes[:name]
      end
    end

    class EtAl < Node
      has_no_children
      attr_struct :term, :'text-case', *Schema.attr(:affixes, :font)

      attr_defaults :term => 'et-al'
    end

    class Substitute < Node
    end


  end
end
