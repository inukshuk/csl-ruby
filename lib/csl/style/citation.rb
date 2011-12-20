module CSL
  class Style
    
    class Citation < Node
      
      attr_struct :'cite-group-delimiter', :collapse, :'year-suffix-delimiter',
        :'after-collapse-delimiter', :'disambiguate-add-names',
        :'disambiguate-add-givenname', :'disambiguate-add-year-suffix',
        :'givenname-disambiguation-rule', :'names-delimiter',
        *Schema.attr(:names, :name)
    
    end
    
  end
end