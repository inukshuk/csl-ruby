module CSL  
  class Locale
    
    # A localized Date comprises a set of formatting rules for dates.
		Date = Struct.new(:form, *Schema.attr(:font, :delimiter, :textcase)) do
		  
		  attr_reader :parts
		  
		  def initialize(attributes = {})
		    super(*attributes.values_at(*members))
		    @parts = []
		  end

      %w{ text numeric }.each do |type|
        define_method("#{type}?") { form == type }
      end

		end
		
		# DatePart represent the localized formatting options for an individual
		# date part (day, month, or year).
		DatePart = Struct.new(:name, *Schema.attr(:affixes, :textcase, :font, :periods, :date)) do
      
		  def initialize(attributes = {})
		    super(*attributes.values_at(*members))
		  end

      %w{ day month year }.each do |part|
        define_method("#{part}?") { name == part }
      end
      
      def to_xml
        "<date-part #{ each_pair.map { |a,v| v ? [a,v.inspect].join('=') : nil }.compact.join(' ') }/>"
      end
		end
		
		
  end
end
