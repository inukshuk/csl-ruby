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
			
			def find(query)
				detect { |t| t.matches?(query) }
			end
			alias [] find
			
    end
    
    class Term < Node
      attr_struct :name, :form, :gender, :'gender-form'
      attr_children :single, :multiple

      attr_accessor :text

			def_delegators :attributes, :hash, :eql?, :name, :form, :gender

      def gendered?
        !attributes.gender.blank?
      end
    
      def neutral?
        !gendered?
      end
  
			def textnode?
				!text.blank?
			end
			
      def singularize
				textnode? ? text : children.single.to_s
      end
      alias singular singularize
      
      def pluralize
				textnode? ? text : children.multiple.to_s
      end      
      alias plural pluralize

      # Tests whether or not the Term matches the passed-in query. Tests
      # vary slightly depending on the the query's type: if a String or
      # Regexp is passed-in, the return value will be true if the Term's
      # name matches the query (disregarding all other attributes); if the
      # query is a Hash, however, the return value will only be true if
      # all passed-in attributes
      #
      # @param query [Hash,Regexp,#to_s] the query
      # @raise [ArgumentError] if the term cannot be matched using query
      #
      # @return [Boolean] whether or not the query matches the term
			def match?(query)
				case
				when query.is_a?(Hash)
					query.symbolize_keys.values_at(*attributes.keys) == attributes.to_a
				when query.is_a?(Regexp)
				  query =~ name
				when query.respond_to?(:to_s)
					query.to_s == name
				else
					raise ArgumentError, "cannot match term to query: #{query.inspect}"
				end
			end
			alias matches? match?
			
			
			# @!method masculine?
			# @return [Boolean] whether or not the term is masculine

			# @!method masculine!
			# @return [self,nil] the term with the gender attribute set to
			#   'masculine', or nil if the term was already masculine

			# @!method feminine?
			# @return [Boolean] whether or not the term is feminie

			# @!method feminine!
			# @return [self,nil] the term with the gender attribute set to
			#   'feminine', or nil if the term was already feminine
      %w{ masculine feminine }.each do |name|
        define_method("#{name}?") do
					attributes.gender.to_s == name
				end
				
        define_method("#{name}!") do
					return nil if attributes.gender.to_s == name
					attributes.gender = name
					self
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