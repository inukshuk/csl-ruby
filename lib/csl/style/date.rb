module CSL
  class Style
    
    class Date < Node
      attr_struct :name, :form, :'range-delimiter', :'date-parts',
        *Schema.attr(:affixes, :display, :font, :textcase)      
    end
    
    class DatePart < Node
      attr_struct :name, :form, :'range-delimiter',
        *Schema.attr(:affixes, :textcase, :font, :periods)
    end
    
    
  end
end