module CSL
  class Style
    
    class Bibliography < Node
      
      attr_struct :'hanging-indent', :'second-field-align', :'line-spacing',
        :'entry-spacing', :'note-distance', :'subsequent-author-substitute',
        :'subsequent-author-substitute-rule', *Schema.attr(:name, :names)
      
      attr_children :sort, :layout
      
    end
    
  end
end