module CSL
  class Style
    
    class Number < Node
      attr_struct :variable, :form, :'text-case',
        *Schema.attr(:affixes, :display, :font)
      

      # @return [Boolean] whether or not the number's format is set to
      #   :numeric; also returns true if the number's form attribute is not
      #   set or nil.
      def numeric?
        !attribute?(:form) || attributes.form.to_sym == :numeric
      end

      # @return [Boolean] whether or not the number's format is set to :ordinal
      def ordinal?
        attribute?(:form) && attributes.form.to_sym == :ordinal
      end
      
      # @return [Boolean] whether or not the number's format is set to :'long-ordinal'
      def long_ordinal?
        attribute?(:form) && attributes.form.to_sym == :'long-ordinal'
      end
      
      # @return [Boolean] whether or not the number's format is set to :roman
      def roman?
        attribute?(:form) && attributes.form.to_sym == :roman
      end
            
    end

  end
end