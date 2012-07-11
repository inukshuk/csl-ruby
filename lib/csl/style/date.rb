module CSL
  class Style
    
    class Date < Node
      attr_struct :name, :form, :'range-delimiter', :'date-parts', :variable,
        :'text-case', *Schema.attr(:affixes, :display, :font, :delimiter)   
    end
    
    class DatePart < Node
      attr_struct :name, :form, :'range-delimiter', :'text-case',
        *Schema.attr(:affixes, :font, :periods)
    end
    
    
  end
end