module CSL
  class Style
    
    Names = Node.new(:variable, *Schema.attr(:names)) do
      
    end
    
    Name = Node.new(:form, *Schema.attr(:name, :affixes, :font, :delimiter)) do
      
    end
   
    NamePart = Node.new(:name, *Schema.attr(:textcase, :affixes, :font)) do
      
    end
        
    EtAl = Node.new(:term, *Schema.attr(:affixes, :font)) do
    end
    
    # Substitute = Node.new() do
    # end
    
  end
end