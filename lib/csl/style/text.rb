module CSL
  class Style

    class Text < Node
      attr_struct :variable, :macro, :term, :form, :plural, :value,
        *Schema.attr(:formatting, :display, :periods)

      has_no_children
    end

  end
end