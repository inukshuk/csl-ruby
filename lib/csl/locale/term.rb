module CSL
  class Locale
    
    class Terms < Node
      attr_children :term
      
      alias terms term
      def_delegators :terms, :size, :length
      
      undef_method :[]=
      
      def initialize(attributes = {})
        super(attributes)      
        @registry, children[:term] = Hash.new { |h,k| h[k] = [] }, []

        yield self if block_given?
      end

      alias each each_child
      
      def lookup(query)
        query = { :name => query } unless query.is_a?(Hash)
        
        terms = if query[:name].is_a?(Regexp)
          registry.select { |name, _| name =~ query[:name] }.flatten(1)
        else
          registry[query[:name].to_s]
        end

        terms.detect { |t| t.exact_match?(query) }
      end
      
      alias [] lookup
      
      private
      
      # @!attribute [r] registry
      # @return [Hash] a private registry to map term names to the respective
      #   term objects for quick term look-up
      attr_reader :registry
      
      def added_child(term)
        raise ValidationError, "failed to register term #{term.inspect}: name attribute missing" unless
          term.attribute?(:name)
          
        registry[term[:name]].push(term)
        term
      end
      
      def deleted_child(term)
        registry[term[:name]].delete(term)
      end
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
        return text if textnode?
        children.single.to_s
      end

      alias singular singularize
      
      def pluralize
        return text if textnode?
        children.multiple.to_s
      end      

      alias plural pluralize      
      
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

      # @param options [Hash,nil] an optional configuration hash
      #
      # @option options [:singular,:plural] :number (:singular) whether to
      #   return the term's singular or plural variant.
      # @option options [Boolean] :plural (false) whether or not to return
      #   the term's plural variant (this option, if set, takes precedence
      #   over :number).
      #
      # @return [String] the term as a string
      def to_s(options = nil)
        if textnode?
          text
        else
          if pluralize?(options)
            pluralize
          else
            singularize
          end
        end
      end
      
      class Single   < TextNode; end
      class Multiple < TextNode; end
      
      private
      
      def pluralize?(options)
        return false if options.nil?
        
        case
        when options.key?(:plural) || options.key?('plural')
          options[:plural] || options['plural']
        when options.key?(:number) || options.key?('number')
          key = options[:number] || options['number']
        
          if key.is_a?(Fixnum) || key.to_s =~ /^[+-]?\d+$/
            key.to_i > 1
          else
            !key.blank? && key.to_s =~ /^plural/i
          end
        else
          false
        end
      end
        
    end
       
    TextNode.types << Term
  end
end