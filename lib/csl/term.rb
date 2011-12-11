module CSL
    
  class Term
  
    extend Forwardable
  
  
    Value = Struct.new(:single, :multiple, :generic) do
      
      extend Forwardable
      
      def_delegators :to_s, *(String.instance_methods(false) -
        Struct.instance_methods(false)).reject { |m| m.to_s =~ /^(<<|replace)|!$/ }

      def initialize(attributes = {})
        super attributes.values_at(:single, :multiple, :generic)
      end

      alias singular single
      alias singular= single=

      alias plural multiple
      alias plural= multiple=

      alias singularize singular
      alias pluralize plural

      def generic?
        !!generic
      end
      
      def to_s
        (generic || single || multiple).to_s
      end
      
    end


    Options = Struct.new(:form, :gender) do
      
      @default = new('long').freeze
      
      class << self
        attr_reader :default
      end
      
      def initialize(attributes = {})
        super attributes.values_at(:form, :gender)
      end

      def gendered?
        !!gender
      end
      
      %w{ neutral masculine feminine }.each do |name|
        define_method("#{name}?") { gender == name }
        define_method("#{name}!") { self.gender = name }
      end
      
    end


    attr_accessor :name
    
    def_delegator :@values, :[], :[]=
    
    def initialize(name = nil)
			@name = name
      @values = Hash.new do |h,k|
        h[k] = h.fetch(k.is_a?(Options) ? k : Options.new(k), Value.new)
      end
    end
    
    def initialize_copy(other)
      @name = other.name
      @values = Hash[*other.values.map { |k,v| [k.dup, v.dup] }]
      @values.default = other.values.default
    end
    
    protected
    
    attr_reader :values
    
  end
  
end