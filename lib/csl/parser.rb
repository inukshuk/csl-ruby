module CSL
  #
  # A relatively straightforward XML parser that parses CSL using either
  # Nokogiri or REXML.
  #
  class Parser
    include Singleton

    attr_accessor :parser
    
    @engines = {
      :nokogiri => lambda { |source|
        Nokogiri::XML::Document.parse(source, nil, nil,
          Nokogiri::XML::ParseOptions::DEFAULT_XML | Nokogiri::XML::ParseOptions::NOBLANKS)
      },
      :default  => lambda { |source|
        REXML::Document.new(source, :compress_whitespace => :all, :ignore_whitespace_nodes => :all)
      }
    }
    
    class << self
      attr_reader :engines
    end
    
    def initialize
      require 'nokogiri'
      @parser = Parser.engines[:nokogiri]
    rescue LoadError
      require 'rexml/document'
      @parser = Parser.engines[:default]
    end
    
    def parse(*arguments)
      parse!(*arguments)
    rescue
      nil
    end
    
    def parse!(source)
      parse_tree parser[source].children.detect { |child| !comment?(child) }
    end

    private
    
    def parse_node(node)
      attributes, text = parse_attributes(node), parse_text(node)
      
      unless text
        Node.create node.name, attributes
      else
        n = TextNode.create node.name, attributes
        n.text = text
        n
      end
    end
    
    def parse_attributes(node)
      Hash[*node.attributes.map { |n, a|
        [n.to_sym, a.respond_to?(:value) ? a.value : a.to_s]
      }.flatten]
    end
    
    def parse_tree(node)
			return nil if node.nil?
			
      root = parse_node node

      node.children.each do |child|
        root << parse_tree(child) unless comment?(child)
      end unless root.textnode?
      
      root
    end
    
    def parse_text(node)
      if node.respond_to?(:has_text?)
        node.has_text? && node.text
      else
        child = node.children[0]
        child && child.respond_to?(:text?) && child.text? && child.text
      end
    end
    
		def comment?(node)
			node.respond_to?(:comment?) && node.comment? ||
				node.respond_to?(:node_type) && [:comment, :xmldecl].include?(node.node_type)
		end
		
  end
  
end