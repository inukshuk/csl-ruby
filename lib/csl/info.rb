module CSL
  
  class Info < Node

    attr_children :author, :category, :contributor, :id, :issn, :eissn,
      :issnl, :link, :published, :rights, :summary, :title, :'title-short',
      :updated, :'link-dependent-style'
    
    
    Contributor = Struct.new(:name, :email, :uri, :role) do

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
    
    class Link < TextNode
      attr_struct :href, :rel
    end

    class Category < TextNode
      attr_struct :field, :'citation-format'
    end    
    
    
  end
    
  
end