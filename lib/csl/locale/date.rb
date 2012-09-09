module CSL
  class Locale

    # A localized Date comprises a set of formatting rules for dates.
		class Date < Node

		  attr_struct :form, :'text-case', *Schema.attr(:font, :delimiter)
		  attr_children :'date-part'

		  alias parts  date_part
		  alias locale parent

		  def initialize(attributes = {})
		    super(attributes)
		    children[:'date-part'] = []

		    yield self if block_given?
		  end
      
			def added_to(node)
				raise ValidationError, "parent must be locale node: was #{node.inspect}" unless node.is_a?(Locale)
			end

      %w{ text numeric }.each do |type|
        define_method("#{type}?") { attributes.form == type }
      end

		end

		# DatePart represent the localized formatting options for an individual
		# date part (day, month, or year).
		class DatePart < Node
      has_no_children

      attr_struct :name, :form, :'range-delimiter', :'text-case',
        *Schema.attr(:affixes, :font, :periods)

      %w{ day month year }.each do |part|
        define_method("#{part}?") do
          attributes.name == part
        end
      end

		end


  end
end
