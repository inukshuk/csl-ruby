module CSL  
  class Locale
    
    # A localized Date comprises a set of formatting rules for dates.
		class Date < Node
		  
		  attr_struct :form, *Schema.attr(:font, :delimiter, :textcase)
		  attr_children :'date-part'
		  
		  alias parts date_part
		  
		  def initialize(attributes = {})
		    super
		    children[:'date-part'] = []
		  end
		  
      %w{ text numeric }.each do |type|
        define_method("#{type}?") { attributes.form == type }
      end
      
		end

		# DatePart represent the localized formatting options for an individual
		# date part (day, month, or year).
		class DatePart < Node
      has_no_children    
      
      attr_struct :name, :form, :'range-delimiter',
        *Schema.attr(:affixes, :textcase, :font, :periods)

      %w{ day month year }.each do |part|
        define_method("#{part}?") do
          attributes.name == part
        end
      end

		end
		
		
  end
end
