module CSL
  class Style

    class Label < Node

      attr_struct :variable, :form, :plural,
        *Schema.attr(:formatting, :periods)

      has_no_children

      def has_variable?
        attribute?(:variable)
      end

      def variable
        attributes[:variable]
      end

      def locator?
        variable.to_s =~ /^locator$/i
      end

      def page?
        variable.to_s =~ /^page$/i
      end

      def always_pluralize?
        attributes[:plural].to_s =~ /^always$/i
      end

      def never_pluralize?
        attributes[:plural].to_s =~ /^never$/i
      end

    end

  end
end