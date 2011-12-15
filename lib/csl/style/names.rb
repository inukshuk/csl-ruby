module CSL
  class Style
    
    class Names < Node
      
      attr_struct :variable, *Schema.attr(:names)      
      
    end
    
    
    class Name < Node
    
      attr_struct :form, *Schema.attr(:name, :affixes, :font, :delimiter)

    end

    class NamePart < Node
      attr_struct :name, *Schema.attr(:textcase, :affixes, :font)
    end
    
    class EtAl < Node
      attr_struct :term, *Schema.attr(:affixes, :font)
    end

    class Substitute < Node
    end
    
    
  end
end