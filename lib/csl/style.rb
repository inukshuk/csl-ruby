module CSL
  
  class Style < Node
    
    @default = :apa

    @root = File.expand_path('../../../vendor/styles', __FILE__).freeze
        
    @extension = '.csl'.freeze
    @prefix = ''
    
    class << self
      include Loader
      
      attr_accessor :default

      def parse(data)
        node = CSL.parse!(data)
        
        raise ParseError, "root node is not a style: #{node.inspect}" unless
          node.is_a?(self)
        
        node
      end
      
    end
    
    attr_defaults :version => Schema.version, :xmlns => Schema.namespace
    
    attr_struct :xmlns, :version, :class, :'default-locale',
      :'initialize-with-hyphen', :'page-range-format',
      :'demote-non-dropping-particle', *Schema.attr(:name, :names)
    
    attr_children :'style-options', :info, :locale, :macro, :citation,
      :bibliography
    
    alias metadata info
    alias options  style_options
    
    def initialize(attributes = {})
      super(attributes)
      children[:info] = Info.new
      children[:macro] = []
      
      yield self if block_given?
    end
    
    
  end
    
end