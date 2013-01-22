module CSL
  class Style

    class Names < Node

      attr_struct :variable, *Schema.attr(:names, :delimiter, :affixes, :display, :font)

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

      attr_children :'name-part'

      alias parts name_part

      def initialize(attributes = {})
        super(attributes)
        children[:'name-part'] = []

        yield self if block_given?
      end

    end

    class NamePart < Node
      has_no_children
      attr_struct :name, :'text-case', *Schema.attr(:affixes, :font)
    end

    class EtAl < Node
      has_no_children
      attr_struct :term, *Schema.attr(:affixes, :font)
    end

    class Substitute < Node
    end


  end
end