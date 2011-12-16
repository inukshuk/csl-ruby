module CSL
  
  class Info < Node

    attr_children :author, :category, :contributor, :id, :issn, :eissn,
      :issnl, :link, :published, :rights, :summary, :title, :'title-short',
      :updated, :'link-dependent-style'
    
    
    class Contributor < Node
      attr_children :name, :email, :uri
    end
    
    class Author < Node
      attr_children :name, :email, :uri
    end
    
    class Translator < Node
      attr_children :name, :email, :uri
    end
    
    class Link < TextNode
      attr_struct :href, :rel
    end

    class Category < TextNode
      attr_struct :field, :'citation-format'
    end    
    
  end
    
  
end