module CSL
  class Style
    
    class Label < Node
   
      has_no_children
      
      attr_struct :variable, :form, :plural, :'text-case',
        *Schema.attr(:affixes, :font, :periods)
      
    end
    
  end
end