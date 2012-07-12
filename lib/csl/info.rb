module CSL
  
  class Info < Node

    attr_children :title, :'title-short', :id, :issn, :eissn, :issnl,
      :link, :author, :contributor, :category, :published, :summary,
      :updated, :rights, :'link-dependent-style'
    
    alias_child :contributors, :contributor
    alias_child :links, :link
    
    class Contributor < Node
      attr_children :name, :email, :uri
    end
    
    class Author < Node
      attr_children :name, :email, :uri
    end
    
    class Translator < Node
      attr_children :name, :email, :uri
    end
    
    class Link < Node
      attr_struct :href, :rel
    end

    class DependentStyle < TextNode
      attr_struct :href, :rel
    end


    class Category < Node
      attr_struct :field, :'citation-format'
    end    

    class Id < TextNode
    end
    
    class Name < TextNode
    end
    
    class Email < TextNode
    end

    class Title < TextNode
    end

    class ShortTitle < TextNode
    end

    class Summary < TextNode
    end
    
    class Rights < TextNode
    end

    class Uri < TextNode
    end

    class Updated < TextNode
    end

  end
    
  
end