module CSL
  
  class Style < Node
    
    attr_struct :version, :class, :'default-locale', :'initialize-with-hyphen',
      :'page-range-format', :'demote-non-dropping-particle',
      *Schema.attr(:name, :names)
      
  end
  
end