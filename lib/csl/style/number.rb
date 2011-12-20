module CSL
  class Style
    
    class Number < Node
      attr_struct *Schema.attr(:affixes, :display, :font, :textcase)
            
    end
    
  end
end