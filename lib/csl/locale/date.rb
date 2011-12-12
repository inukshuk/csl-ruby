module CSL  
  class Locale
    
    # A localized Date comprises a set of formatting rules for dates.
		Date = Struct.new(:form, *Schema.attr(:font, :delimiter, :textcase)) do
		  
		  extend Forwardable
		  
		  attr_reader :parts
		  
		  def_delegator :@parts, :empty?
		  
		  def initialize(attributes = {})
		    super(*attributes.values_at(*members))
		    @parts = []
		  end

      %w{ text numeric }.each do |type|
        define_method("#{type}?") { form == type }
      end
      
      def to_xml
        if empty?
          "<date #{ attribute_list }/>"
        else
          ['<date ', attribute_list, '>', parts.map(&:to_xml).join, '</date>'].join
        end
      end
      
      private
      
      def attribute_list
        each_pair.map { |name, value|
          value ? [name, value.inspect].join('=') : nil
        }.compact.join(' ')
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
        "<date-part #{ attribute_list }/>"
      end
      
      private
      
      def attribute_list
        each_pair.map { |name, value|
          value ? [name, value.inspect].join('=') : nil
        }.compact.join(' ')
      end
      
		end
		
		
  end
end
