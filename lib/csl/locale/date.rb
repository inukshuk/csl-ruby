module CSL  
  class Locale
    
    # A localized Date comprises a set of formatting rules for dates.
		class Date < Node
		  
		  attr_struct :form, *Schema.attr(:font, :delimiter, :textcase)
		  
		  alias empty? has_children?
		  alias parts  children
		  
      %w{ text numeric }.each do |type|
        define_method("#{type}?") { attributes.form == type }
      end
      
		end

		# DatePart represent the localized formatting options for an individual
		# date part (day, month, or year).
		class DatePart < Node

      attr_struct :name, :form, :'range-delimiter', *Schema.attr(:affixes, :textcase, :font, :periods)

		  alias empty? has_children?

      %w{ day month year }.each do |part|
        define_method("#{part}?") { attributes.name == part }
      end

		end
		
		
  end
end
