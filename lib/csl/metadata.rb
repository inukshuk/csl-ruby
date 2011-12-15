module CSL
  
  class Metadata < Node
    
    attr_struct *Schema.metadata

    def initialize(attributes = {})
      super
      @nodename = 'info'
    end
    
    def to_tags
      tags = []
      tags << "<#{nodename}>"
      
      tags << each_pair.map { |name, value|
        value ? ["<#{name}>", value, "</#{name}>"] : nil
      }.compact
      
      tags << "</#{nodename}>"
      tags
    end
    
    alias children values
    
    def inspect
      "#<#{self.class.name} children=[#{children.length}]>"
    end
      
    class Link < Node
      attr_struct :href, :rel
    end
    
    class Category < Node
      attr_struct :field, :'citation-format'
    end
  
  end
  
    
  Metadata::Contributor = Struct.new(:name, :email, :uri, :role) do

    include PrettyPrinter

    def initialize(attributes = {})
      super(*attributes.values_at(*members))
    end

    def nodename
      role || 'contributor'
    end
    
    def to_tags
      ["<#{nodename}>", content.compact,"</#{nodename}>"]
    end
    
    def content
      each_pair.map do |name, value|
        name != :role && value ? "<#{name}>#{value}</#{name}>" : nil
      end
    end
          
    def inspect
      super.sub!(/struct/, self.class.name)
    end
  end

    
  
end