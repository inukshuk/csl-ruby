module CSL
  class Style
    
    class Label < Node
      
      attr_struct :variable, :form, :plural,
        *Schema.attr(:affixes, :font, :textcase, :periods)
      
    end
    
  end
end