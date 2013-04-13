module CSL
  class Style

    # Numbers are CSL rendering elements which output the number variable
    # selected with the required variable attribute.
    class Number < Node
      attr_struct :variable, :form, :'text-case',
        *Schema.attr(:affixes, :display, :font)

      has_no_children

      def has_variable?
        attribute?(:variable)
      end

      def variable
        attributes[:variable]
      end

      def has_form?
        attribute?(:form)
      end

      def form
        attributes[:form]
      end

      # @return [Boolean] whether or not the number's format is set to
      #   :numeric; also returns true if the number's form attribute is not
      #   set or nil.
      def numeric?
        !has_form? || form.to_sym == :numeric
      end

      # @return [Boolean] whether or not the number's format is set to :ordinal
      def ordinal?
        has_form? && form.to_sym == :ordinal
      end

      # @return [Boolean] whether or not the number's format is set to :'long-ordinal'
      def long_ordinal?
        has_form? && form.to_sym == :'long-ordinal'
      end

      # @return [Boolean] whether or not the number's format is set to :roman
      def roman?
        has_form? && form.to_sym == :roman
      end
    end

  end
end