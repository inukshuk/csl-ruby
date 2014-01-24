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
end
