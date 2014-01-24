module CSL
  module InheritableNameOptions
    def inheritable_name_options
      options = attributes_for *Schema.attr(:name)

      options[:delimiter] = attributes[:'name-delimiter'] if attribute?(:'name-delimiter')
      options[:form] = attributes[:'name-form'] if attribute?(:'name-form')

      options
    end

    def inheritable_names_options
      return {} unless attribute? :'names-delimiter'
      { :delimiter => attributes[:'names-delimiter'] }
    end
  end

  module InheritsNameOptions
    def inherits(name)
      inheritable_options = "inheritable_#{name}".to_sym

      define_method("inherited_#{name}") do |mode|
        options = {}

        if !root? && root.respond_to?(inheritable_options)
          if !mode.nil? && root.respond_to?(mode)
            node = root.send(mode)

            if node.respond_to?(inheritable_options)
              options = node.send(inheritable_options).merge(options)
            end
          end

          options = root.send(inheritable_options).merge(options)
        end

        options
      end
    end
  end
end
