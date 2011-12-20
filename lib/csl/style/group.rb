module CSL
  class Style
    
    class Group < Node
      attr_struct *Schema.attr(:affixes, :display, :delimiter)      
    end
    
  end
end