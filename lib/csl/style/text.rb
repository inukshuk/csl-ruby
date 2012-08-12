module CSL
  class Style

    class Text < Node
      attr_struct :variable, :macro, :term, :form, :plural, :value,
        *Schema.attr(:formatting, :display, :quotes, :periods)

      has_no_children

			def has_variable?
				attribute?(:variable)
			end

			def variable
				attributes[:variable]
			end
			
			def variable_options
				attributes_for :form
			end

			def has_macro?
				attribute?(:macro)
			end

			# @return [Macro, nil]
			def macro
				raise unless parent.respond_to?(:macros)
				parent.macros[attributes[:macro]]
			end

			def has_term?
				attribute?(:term)
			end

			def term_options
				attributes_for :term, :plural, :form
			end

			def has_value?
				attribute?(:value)
			end

			def value
				attributes[:value]
			end
    end

  end
end