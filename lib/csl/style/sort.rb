module CSL
  
  class Sort < Node
    
    attr_children :key

    alias keys key
    
    def initialize(attributes = {})
      super(attributes)
      children[:key] = []
      
      yield self if block_given?
    end
    
    class Key < Node
    end
    
  end
  
end