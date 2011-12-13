module CSL
  class Style
    
    Date = Node.new(*Schema.attr(:date)) do
      
    end

    DatePart = Node.new(:name, :form, :'range-delimiter', *Schema.attr(:affixes, :textcase, :font, :periods)) do
      
    end
    
  end
end