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

      def substitute_subsequent_author?
        attribute?(:'subsequent-author-substitute')
      end

      def subsequent_author_substitute
        attribute[:'subsequent-author-substitute'].to_s
      end

      def subsequent_author_substitute_rule
        attribute[:'subsequent-author-substitute-rule'].to_s
      end

      def substitute_subsequent_authors_completely?
        return false unless substitute_subsequent_author?
        subsequent_author_substitute_rule == 'complete-all'
      end

      def substitute_subsequent_authors_individually?
        return false unless substitute_subsequent_author?
        subsequent_author_substitute_rule != 'complete-all'
      end
    end

  end
end
