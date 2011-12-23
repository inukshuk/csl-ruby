module CSL
  class Style
    
    class Label < Node
   
      has_no_children
      
      attr_struct :variable, :form, :plural,
        *Schema.attr(:affixes, :font, :textcase, :periods)
      
    end
    
  end
end