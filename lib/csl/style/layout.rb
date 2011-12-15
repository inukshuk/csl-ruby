module CSL
  class Style
    
    class Layout < Node
      attr_struct *Schema.attr(:affixes, :font, :delimiter)
    
    end
    
  end
end