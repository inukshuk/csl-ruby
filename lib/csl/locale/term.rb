module CSL
  class Locale
    
    Term = Struct.new(:name, :form, :gender, :'gender-form') do
      extend Forwardable
  
      attr_accessor :value
      
      def initialize(attributes = {})
        super(*attributes.values_at(*members))
        @value = attributes[:value].to_s
      end

      def initialize_copy(other)
        super
        @value = other.value.dup
      end
      
      def code
        [name, form, gender].join.sum
      end
      
      def gendered?
        !!gender
      end
    
      def neutral?
        !gendered?
      end
  
      def singularize
        value && value.respond_to?(:single) ? value.single : value.to_s
      end
      alias singular singularize
      
      def pluralize
        value && value.respond_to?(:multiple) ? value.multiple : value.to_s
      end
      alias plural pluralize

      %w{ masculine feminine }.each do |name|
        define_method("#{name}?") { gender == name }
        define_method("#{name}!") { gender == name ? nil : self.gender = name }
      end

      def nodename
        self.class.name.split(/::/)[-1].downcase
      end
      
      def to_xml
        "<#{nodename} #{attribute_list}>#{content}</#{nodename}>"
      end
      
      def content
        value.respond_to?(:to_xml) ? value.to_xml : value.to_s
      end
      
      private
      
      def attribute_list
        each_pair.map { |name, value|
          value ? [name, value.inspect].join('=') : nil
        }.compact.join(' ')
      end
    
    end
    
    Term::Value = Struct.new(:single, :multiple) do
      extend Forwardable
      
      def_delegators :to_s, *(String.instance_methods(false) -
        Struct.instance_methods(false)).reject { |m| m.to_s =~ /^(<<|replace)|!$/ }

      def initialize(attributes = {})
        super(*attributes.values_at(:single, :multiple))
      end
    
      def to_xml
        "<single>#{single}</single><multiple>#{multiple}</multiple>"
      end
    
    end
    
  
  end
end