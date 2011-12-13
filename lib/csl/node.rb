module CSL
  
  class Node < Struct
    
    include Treelike

    @tabwidth = 2
    
    class << self
      attr_accessor :tabwidth
    end

    
    def initialize(attributes = {})
      super(*attributes.values_at(*members))
    end
    
    # Returns the node's attributes as a hash/
    def attributes
      Hash[*each_pair.to_a]
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
    
    def to_xml
      to_tags.flatten.join
    end
    
    def pretty_print
      pp(to_tags).join("\n")
    end
        
    alias to_s pretty_print
    
    def inspect
      "#<#{self.class.name} attributes={#{size}} children=[#{children.length}]>"
    end
    
    
    private
    
    # pretty printer helper
    def pp(tags, level = 0)
      tags.map do |tag|
        if tag.respond_to?(:map)
          pp tag, level + 1
        else
          ' ' * (level * Node.tabwidth) + tag.to_s
        end
      end
    end
    
    def attribute_assignments
      each_pair.map { |name, value|
        value ? [name, value.to_s.inspect].join('=') : nil
      }.compact
    end
    
  end
  
end