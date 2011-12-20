module CSL
  class Style
    
    class Text < Node
      attr_struct :macro, :term, :form, :plural, :value,
        *Schema.attr(:affixes, :display, :font, :quotes, :periods, :textcase)
    end
    
  end
end