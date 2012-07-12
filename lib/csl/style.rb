module CSL
  
  class Style < Node
    types << CSL::Info << CSL::Locale
    
    @default = :apa

    @root = File.expand_path('../../../vendor/styles', __FILE__).freeze
        
    @extension = '.csl'.freeze
    @prefix = ''
    
    class << self
      include Loader
      
      attr_accessor :default

      def parse(data)
        node = CSL.parse!(data, self)
        
        raise ParseError, "root node is not a style: #{node.inspect}" unless
          node.is_a?(self)
        
        node
      end      
    end
    
    attr_defaults :version => Schema.version, :xmlns => Schema.namespace
    
    attr_struct :xmlns, :version, :class, :'default-locale',
      :'initialize-with-hyphen', :'page-range-format',
      :'demote-non-dropping-particle', *Schema.attr(:name, :names)
    
    attr_children :'style-options', :info, :locale, :macro,
      :citation, :bibliography
    
    alias metadata info
    alias options  style_options
    alias locales  locale
    
    def_delegators :info, :self_link, :has_self_link?, :template_link,
      :has_template_link?, :documentation_link, :has_documentation_link?
      
    def initialize(attributes = {})
      super(attributes, &nil)      
      children[:locale], children[:macro] = [], []
      
      yield self if block_given?
    end

    def validate
      Schema.validate self
    end
    
    def valid?
      validate.empty?
    end
    
    def info
      children[:info] ||= Info.new
    end
    
    private
    
    def preamble
      Schema.preamble.dup
    end 
  end
 
end