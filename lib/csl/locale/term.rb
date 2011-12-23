module CSL
  class Locale
    
    class Terms < Node
      attr_children :term
      
      alias terms term
			def_delegators :terms, :size, :length
			
			undef_method :[]=
			
      def initialize(attributes = {})
        super(attributes)
        children[:term] = []

				yield self if block_given?
      end

			alias each each_child
			
			def [](query)
				detect { |t| t.matches?(query) }
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

			def match?(query)
				case
				when query.is_a?(Hash)
					query.values_at(*attributes.members) == attributes.to_a
				when query.respond_to?(:to_s)
					query.to_s == name
				else
					raise ArgumentError, "cannot match term to query: #{query.inspect}"
				end
			end
			alias matches? match?
			
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
			
			class Single   < TextNode; end
			class Multiple < TextNode; end
				
    end
       
  	TextNode.types << Term
  end
end