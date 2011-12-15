module CSL
  module PrettyPrinter
    
    def to_tags
      raise 'not implemened by base class'
    end
    
    def to_xml
      to_tags.flatten.join
    end
    
    def pretty_print
      pp(to_tags).join("\n")
    end

    private
    
		def tabwidth
			2
		end
		
    def pp(tags, level = 0)
      tags.map do |tag|
        if tag.respond_to?(:map)
          pp tag, level + 1
        else
          ' ' * (level * tabwidth) + tag.to_s
        end
      end
    end
    
  end
end