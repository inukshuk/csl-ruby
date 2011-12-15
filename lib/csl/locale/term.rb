module CSL
  class Locale
    
    class Term < Node

      attr_struct :name, :form, :gender, :'gender-form'
  
      attr_accessor :value
      
      def initialize(attributes = {})
        super
        @value = Term::Value.parse(attributes[:value])
      end

      def initialize_copy(other)
        super
        @value = other.value.dup
      end

      def children
        Array(value)
      end
      
      def code
        [name, form, gender].join.sum
      end
      
      def gendered?
        !!gender
      end
    
      def neutral?
        !gendered?
      end
  
      def singularize
        value && value.respond_to?(:single) ? value.single : value.to_s
      end
      alias singular singularize
      
      def pluralize
        value && value.respond_to?(:multiple) ? value.multiple : value.to_s
      end
      
      alias plural pluralize

      %w{ masculine feminine }.each do |name|
        define_method("#{name}?") { gender == name }
        define_method("#{name}!") { gender == name ? nil : self.gender = name }
      end
      
    end
    
    Term::Value = Struct.new(:single, :multiple) do
      extend Forwardable
      include PrettyPrinter
      
      class << self
        
        def parse(data)
          case data
          when String
            data.to_s
          when Hash
            new(data)
          else
            nil
          end
        end
        
      end
      
      def_delegators :to_s, *(String.instance_methods(false) -
        Struct.instance_methods(false)).reject { |m| m.to_s =~ /^(<<|replace)|!$/ }

      def initialize(attributes = {})
        super(*attributes.values_at(*members))
      end

      def to_tags
        each_pair.map { |name, value|
          value ? "#<{name}>#{value}</#{name}>" : nil
        }.compact
      end      
    
    end
    
  
  end
end