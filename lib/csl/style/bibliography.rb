module CSL
  class Style

    class Bibliography < Node

      include InheritableNameOptions

      attr_struct :'subsequent-author-substitute',
        :'subsequent-author-substitute-rule',
        *Schema.attr(:bibliography, :name, :names)

      attr_children :sort, :layout

      attr_defaults :'line-spacing' => 1, :'entry-spacing' => 1,
        :'subsequent-author-substitute-rule' => 'complete-all'

      alias sort? has_sort?

      def bibliography_options
        attributes_for *Schema.attr(:bibliography)
      end

      def sort_keys
        return [] unless sort?
        children[:sort].descendants
      end

      def subsititute_subsequent_author?
        attribute?(:'subsequent-author-substitute') && subsequent_author_substitute != 'false'
      end

      def subsequent_author_substitute
        attribute[:'subsequent-author-substitute'].to_s
      end

      def subsequent_author_substitute_rule
        attribute[:'subsequent-author-substitute-rule'].to_s
      end
    end

  end
end
