module CSL
  class Style

    class Bibliography < Node

      include InheritableNameOptions

      attr_struct :'subsequent-author-substitute',
        :'subsequent-author-substitute-rule',
        *Schema.attr(:bibliography, :name, :names)

      attr_children :sort, :layout

      attr_defaults :'line-spacing' => 1, :'entry-spacing' => 1

      alias sort? has_sort?

      def bibliography_options
        attributes_for *Schema.attr(:bibliography)
      end

      def sort_keys
        return [] unless sort?
        children[:sort].descendants
      end
    end

  end
end
