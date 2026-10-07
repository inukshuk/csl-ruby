module CSL
  class Style

    class Date < Node
      attr_defaults :'date-parts' => 'year-month-day'

      attr_struct :name, :form, :'range-delimiter', :'date-parts',
				:variable, *Schema.attr(:formatting, :delimiter)

      attr_children :'date-part'

      alias date_parts date_part
      alias parts date_part

      private :date_part

      def initialize(attributes = {})
        super(attributes, &nil)
        children[:'date-part'] = []

        yield self if block_given?
      end

      # @return [Array<String>] the localized date parts to be used
      def date_parts_filter
        attributes[:'date-parts'].to_s.split(/-/)
      end
      alias parts_filter date_parts_filter

      def delimiter
        attributes.fetch(:delimiter, '')
      end

      def has_variable?
        attribute?(:variable)
      end

      def variable
        attributes[:variable]
      end

      def has_form?
        attribute?(:form)
      end
      alias localized? has_form?

      def form
        attributes[:form].to_s
      end

      def numeric?
        form =~ /^numeric$/i
      end

      def text?
        form =~ /^text$/i
      end

      def has_date_parts?
        !date_parts.empty?
      end
      alias has_parts? has_date_parts?

      def has_overrides?
        localized? && has_parts?
      end

      # Localized dates use the date parts of the locale's date in the
      # same form, filtered by the date-parts attribute; the date parts of
      # this date override their attributes, except for the affixes.
      #
      # @param locale [CSL::Locale]
      # @raise [CSL::Error] if the locale has no date in the same form
      # @return [Array<CSL::Style::DatePart, CSL::Locale::DatePart>]
      #   the date parts to use
      def parts_for(locale)
        return parts unless localized?

        filter = parts_filter

        localized_date_for(locale).parts
          .select { |part| filter.include?(part.name) }
          .map { |part| override(part) }
      end

      # @param locale [CSL::Locale]
      # @raise [CSL::Error] if the locale has no date in the same form
      # @return [String] the delimiter to use
      def delimiter_for(locale)
        localized? ? localized_date_for(locale).delimiter : delimiter
      end

      private

      def localized_date_for(locale)
        locale.each_date.detect { |date| date.form == form } or
          raise Error, "no localized date for form #{form} found"
      end

      # @return [CSL::Locale::DatePart] the part or a copy
      #   with the attributes of the matching date part
      def override(part)
        override = parts.detect { |p| p.name == part.name }
        return part if override.nil?

        copy = part.deep_copy
        copy.merge! override.attributes.to_hash.except(:prefix, :suffix)
        copy
      end
    end

    class DatePart < Node
      has_no_children

      attr_struct :name, :form, :'range-delimiter', :'strip-periods',
        *Schema.attr(:formatting)

      include CSL::DatePart
    end

  end
end