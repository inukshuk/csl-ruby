module CSL
  class Style
    
    class Choose < Node

      class Block < Node
        
        def self.matches?(nodename)
          nodename.to_s =~ /^if(-else)?|else$/
        end
        
      end
    end
    
  end
end