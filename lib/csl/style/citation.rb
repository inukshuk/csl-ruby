module CSL
  class Style

    class Citation < Node

      include InheritableNameOptions

      attr_struct :'cite-group-delimiter', :collapse, :'year-suffix-delimiter',
        :'after-collapse-delimiter', :'disambiguate-add-names',
        :'disambiguate-add-givenname', :'disambiguate-add-year-suffix',
        :'givenname-disambiguation-rule', *Schema.attr(:names, :name)

      attr_children :sort, :layout

    end

  end
end
