module CSL
  
  class Node
    
		extend Forwardable
		
		include Enumerable
		
    include Treelike
    include PrettyPrinter
    		
		
    class << self

			def default_attributes
			  @default_attributes ||= {}
			end
			
			def create_attributes(attributes)
				if const_defined?(:Attributes)
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
						value = members.include?(key) && send(key)
						
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
    end
    
    
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
		
    def has_attributes?
      !values.reject { |v| v.nil? || v.respond_to?(:empty) && v.empty? }.empty?
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
      "#<#{self.class.name} attributes={#{size}} children=[#{children.length}]>"
    end
    
    alias to_s pretty_print

    
    private
        
    def attribute_assignments
      each_pair.map { |name, value|
        value ? [name, value.to_s.inspect].join('=') : nil
      }.compact
    end
    
  end
  
end