module CSL
  class Style
    
    class Text < Node
      attr_struct :variable, :macro, :term, :form, :plural, :'text-case',
        :value, *Schema.attr(:affixes, :display, :font, :quotes, :periods)
    end
    
  end
end