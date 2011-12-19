module CSL
  class Locale
    
    class Terms < Node
      attr_children :term
      
      alias terms term
      
      def initialize(attributes = {})
        super(attributes)
        children[:term] = []

				yield self if block_given?
      end

    end
    
    class Term < Node
      attr_struct :name, :form, :gender, :'gender-form'
      attr_children :single, :multiple

      attr_accessor :text

			def_delegators :attributes, :hash, :eql?, :name, :form, :gender

      def gendered?
        !!attributes.gender
      end
    
      def neutral?
        !gendered?
      end
  
			def textnode?
				!(text.nil? || text.empty?)
			end
			
      def singularize
				textnode? ? text : children.single.to_s
      end
      alias singular singularize
      
      def pluralize
				textnode? ? text : children.multiple.to_s
      end      
      alias plural pluralize

      %w{ masculine feminine }.each do |name|
        define_method("#{name}?") do
					attributes.gender == name
				end
        define_method("#{name}!") do
					attributes.gender == name ? nil : attributes.gender = name
				end
      end

			def tags
				if textnode?
					["<#{[nodename, *attribute_assignments].join(' ')}>", text, "</#{nodename}>"]
				else
					super
				end
			end
			
			def to_s
				textnode? ? text : [singular, plural].compact.join('/')
			end
			
    end
       
  
  end
end