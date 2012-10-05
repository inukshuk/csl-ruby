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

        @registry = Term::Registry.new
        @ordinals = Term::Registry.new

        yield self if block_given?
      end

      alias each each_child

      def lookup(name, options = {})
        options[:name] = name = name.to_s

        term = registry[name].detect { |t| t.match?(options) }
        return term unless term.nil? && options.delete(:'gender-form')
  
        registry[name].detect { |t| t.match?(options) }
      end
      alias [] lookup
      
      def ordinalize_modulo(number, divisor, options = {})
        ordinal = ordinalize(number, options)
        return unless ordinal && ordinal.match_modulo?(divisor)
        ordinal
      end

      def ordinalize(number, options = {})
        return unless has_ordinals?
        
        if number == :default
          options[:name] = 'ordinal'
        else
          options[:name] = 'ordinal-%02d' % number
        end
        
        if options[:form].to_s =~ /^long/i
          options.delete :form
          options[:name][0,0] = 'long-'
        end
        
        ordinal = ordinals[number].detect { |t| t.match?(options) }
        return ordinal unless ordinal.nil? && options.delete(:'gender-form')
        
        ordinals[number].detect { |t| t.match?(options) }
      end

      # @return [Boolean] whether or not regular terms are registered at this node
      def has_terms?
        not registry.empty?
      end

      # @return [Boolean] whether or not ordinal terms are registered at this node
      def has_ordinals?
        not ordinals.empty?
      end

      def has_legacy_ordinals?
        has_ordinals? && !ordinals.key?(:default)
      end
      
      def drop_ordinals
        tmp = ordinals.values.flatten(1)
        ordinals.clear
        delete_children tmp
      end

      private

      # @!attribute [r] registry
      # @return [Hash] a private registry to map term names to the respective
      #   term objects for quick term look-up
      attr_reader :registry

      # @!attribute [r] ordinals
      # @return [Hash] a private registry to map ordinals to the respective
      #   term objects for quick ordinal look-up
      attr_reader :ordinals

      def added_child(term)
        raise ValidationError, "failed to register term #{term.inspect}: name attribute missing" unless
          term.attribute?(:name)

        if term.ordinal?
          store = ordinals[term.ordinal]
        else
          store = registry[term[:name]]
        end

        delete_children store.select { |value| term.exact_match? value }

        store.push(term)

        term
      end

      def deleted_child(term)
        if term.ordinal?
          ordinals[term.ordinal].delete(term)
        else
          registry[term[:name]].delete(term)
        end
      end
      
    end

    class Term < Node
      attr_struct :name, :form, :gender, :'gender-form', :match
      attr_children :single, :multiple

      attr_accessor :text

      def_delegators :attributes, :hash, :eql?, :name, :form, :gender

      # This method returns whether or not the ordinal term matchs the
      # passed-in modulus. This is determined by the ordinal term's match
      # attribute: a value of '2-digits' matches a divisor of 100, '1-digit'
      # matches a divisor of 10 and 'whole-number' matches a divisor of 1.
      #
      # If the term is no ordinal term, this methods always returns false.
      #
      # @return [Boolean] whether or not the ordinal term matches the
      #   passed-in divisor.
      def match_modulo?(divisor)
        return false unless ordinal?

        case attributes.match
        when '2-digits'
          divisor.to_i == 100
        when '1-digit'
          divisor.to_i == 10
        when 'whole-number'
          divisor.to_i == 1
        else
          true
        end
      end
      alias matches_modulo? match_modulo?

      # @return [Boolean] whether or not this term is an ordinal term
      def ordinal?
        /^(long-)?ordinal(-\d\d+)?$/ === attributes.name
      end

      # @return [Fixnum, :default, nil]
      def ordinal
        return unless ordinal?
        return :default if attributes.name == 'ordinal'
        attributes.name[/\d+/].to_i
      end

      def gendered?
        not attributes.gender.blank?
      end

      def neutral?
        not gendered?
      end

      def textnode?
        not text.blank?
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

      class Registry < ::Hash
        def initialize
          super { |h,k| h[k] = [] }
        end
      end
    end

    TextNode.types << Term
  end
end