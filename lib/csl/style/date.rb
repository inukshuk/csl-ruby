module CSL
  class Style
    
    class Date < Node
      attr_struct *Schema.attr(:date)      
    end
    
    class DatePart < Node
      attr_struct :name, :form, :'range-delimiter', *Schema.attr(:affixes, :textcase, :font, :periods)
    end
    
    
  end
end