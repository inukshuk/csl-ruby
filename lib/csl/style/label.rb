module CSL
  class Style

    class Label < Node

      attr_struct :variable, :form, :plural,
        *Schema.attr(:formatting, :periods)

      has_no_children

      @variables = [:locator, :page].concat(Schema.variables[:number]).freeze

      class << self
        attr_reader :variables
      end

      def has_variable?
        return parent.has_variable? if names_label?
        attribute?(:variable)
      end

      # The value of the node's variable attribute. If the {Label}
      # is the child of a {Names} node, returns the parent's variable
      # attribute instead.
      #
      # @return [String] the value of the node's variable attribute
      def variable
        return parent.variable if name_label?
        attributes[:variable]
      end

      Label.variables.each do |type|
        pattern = Regexp.new("^#{type}", true)

        define_method("#{type}?".tr('-', '_')) do
          variable.to_s =~ pattern
        end
      end

      def always_pluralize?
        attributes[:plural].to_s =~ /^always$/i
      end

      def never_pluralize?
        attributes[:plural].to_s =~ /^never$/i
      end

      # @return [Boolean] whether or not the {Label} is inside a {Names} node
      def names_label?
        parent.is_a?(Names)
      end
      alias name_label? names_label?

    end

  end
end