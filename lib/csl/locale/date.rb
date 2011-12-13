module CSL  
  class Locale
    
    # A localized Date comprises a set of formatting rules for dates.
		Date = Node.new(:form, *Schema.attr(:font, :delimiter, :textcase)) do
		  
		  alias empty? has_children?
		  alias parts  children
		  
      %w{ text numeric }.each do |type|
        define_method("#{type}?") { form == type }
      end
      
		end
		
		# DatePart represent the localized formatting options for an individual
		# date part (day, month, or year).
		DatePart = Node.new(:name, *Schema.attr(:affixes, :textcase, :font, :periods, :date)) do

		  alias empty? has_children?
      
      %w{ day month year }.each do |part|
        define_method("#{part}?") { name == part }
      end
      
		end
		
		
  end
end
