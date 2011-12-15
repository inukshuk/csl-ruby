module CSL
  class Style
    
    class Label < Node
      
      attr_struct :variable, :form, *Schema.attr(:label)
      
    end
    
  end
end