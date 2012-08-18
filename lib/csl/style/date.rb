module CSL
  class Style

    class Date < Node

      attr_defaults :'date-parts' => 'year-month-day'

      attr_struct :name, :form, :'range-delimiter', :'date-parts', :variable,
        *Schema.attr(:display, :formatting, :delimiter)

      attr_children :'date-part'

      alias date_parts date_part
      alias parts date_part

      private :date_part

      def initialize(attributes = {})
        super(attributes, &nil)
        children[:'date-part'] = []

        yield self if block_given?
      end

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

      def form
        attributes[:form]
      end

      def has_date_parts?
        !date_parts.empty?
      end
      alias has_parts? has_date_parts?

    end

    class DatePart < Node
      attr_struct :name, :form, :'range-delimiter',
        *Schema.attr(:formatting, :periods)

      def range_delimiter
        attributes.fetch(:'range-delimiter', '')
      end

      def name
        attributes[:name].to_s
      end

      def has_form?
        attribute?(:form)
      end

      def form
        case
        when has_form?
          attributes[:form]
        when has_parent?
          parent.form
        else
          nil
        end
      end

      def year?
        name =~ /year/i
      end

      def month?
        name =~ /month/i
      end

      def day?
        name =~ /day/i
      end
    end

  end
end