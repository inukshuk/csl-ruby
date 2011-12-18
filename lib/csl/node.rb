module CSL
  
  class Node
    
    extend Forwardable
    
    include Enumerable
    include Comparable
    
    include Treelike
    include PrettyPrinter
        
    
    class << self

      def default_attributes
        @default_attributes ||= {}
      end
      
      def create_attributes(attributes)
        if const_defined?(:Attributes, false)
          const_get(:Attributes).new(default_attributes.merge(attributes))
        else
          default_attributes.merge(attributes)
        end
      end

      private
      
      def attr_defaults(attributes)
        @default_attributes = attributes
      end
      
      def attr_struct(*attributes)
        const_set(:Attributes, Struct.new(*attributes) {
          
          def initialize(attrs = {})
            super(*attrs.values_at(*members))
          end
      
          alias keys members
          
          def fetch(key, default = nil)
            value = members.include?(key.to_sym) && send(key)
            
            if block_given? 
              value || yield(key)
            else
              value || default
            end
          end
          
        })
      end

    end


    attr_reader :attributes

    def_delegators :attributes, :[], :[]=, :values, :values_at, :length, :size
    
    def initialize(attributes = {})
      @attributes = self.class.create_attributes(attributes)
      @children = self.class.create_children
      
      yield self if block_given?
    end
    
    # Iterates through the Node's attributes
    def each
      if block_given?
        attributes.each_pair(&Proc.new)
        self
      else
        to_enum
      end
    end
    alias each_pair each

    # Returns true if the node contains an attribute with the passed-in name;
    # false otherwise.
    def attribute?(name)
      attributes.fetch(name, false)
    end
    
    # Returns true if the node contains any attributes (ignores nil values);
    # false otherwise.
    def has_attributes?
      !detect { |a| !a.nil? }.nil?
    end

    def <=>(other)
      [nodename, attributes, children] <=> [other.nodename, other.attributes, other.children]
    rescue
      nil
    end
    
    # Returns the node' XML tags (including attribute assignments) as an
    # array of strings.
    def to_tags
      if has_children?
        tags = []
        tags << "<#{attribute_assignments.unshift(nodename).join(' ')}>"
        
        tags << children.map do |node|
          node.respond_to?(:to_tags) ? node.to_tags : [node.to_s]
        end
        
        tags << "</#{nodename}>"
        tags
      else
        ["<#{nodename} #{attribute_assignments.join(' ')}/>"]
      end
    end
    
    def inspect
      "#<#{self.class.name} attributes={#{length}} children=[#{children.length}]>"
    end
    
    alias to_s pretty_print

    
    private
        
    def attribute_assignments
      each_pair.map { |name, value|
        value.nil? ? nil: [name, value.to_s.inspect].join('=')
      }.compact
    end
    
  end
  
  
  class TextNode < Node
    
    has_no_children

    class << self
      undef_method :attr_children
    end
    
    attr_accessor :content
    
    alias text  content
    alias text= content= 
    alias to_s  content

    # TextNodes quack like a string.
    # def_delegators :to_s, *String.instance_methods(false).reject do |m|
    #   m.to_s =~ /^\W|!$|(?:^(?:hash|eql?|to_s|length|size|inspect)$)/
    # end
    # 
    # String.instance_methods(false).select { |m| m.to_s =~ /!$/ }.each do |m|
    #   define_method(m) do
    #     content.send(m) if content.respond_to?(m)
    #   end
    # end
    
    def initialize(argument = '')
      case
      when argument.is_a?(Hash)
        super
      when argument.respond_to?(:to_s)
        super({})
        @content = argument.to_s
        yield self if block_given?
      else
        raise ArgumentError, "failed to create text node from #{argument.inspect}"
      end
    end
    
    def to_tags
      tags = []
      tags << "<#{attribute_assignments.unshift(nodename).join(' ')}>"
      tags << content
      tags << "</#{nodename}>"
      tags
    end
    
    def inspect
      "#<#{self.class.name} #{content.inspect} attributes={#{attributes.length}}>"
    end
    
  end
  
end