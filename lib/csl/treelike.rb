module CSL
  
  module Treelike
    
    attr_accessor :parent
    attr_writer :nodename
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    def nodename
      @nodename ||= self.class.name.split(/::/)[-1].gsub(/([[:lower:]])([[:upper:]])/, '\1-\2').downcase
    end
    
    def find_children_by_name(name)
      name = name.to_s
      children.select { |node| node.nodename == name }
    end

    def children
      @children ||= []
    end
    
    def has_children?
      !children.empty?
    end
    
    # Returns all descendants of the node. See #descendants for a memoized
    # version.
    def descendants!
      @descendants = children + children.map(&:children).flatten
    end
    
    # Returns the (memoized) descendants of the node. See #descendants! for
    # the non-memoized version of this method.
    def descendants
      @descendants || descendants!
    end
    
    def add_children(*arguments)
      arguments.flatten(1).compact.each do |node|
        node.parent = self
        children << node
      end

      self
    end
    
    alias :add_child :add_children
    
    
    def ancestors!
      @ancestors = root? ? [] : [parent] + parent.ancestors!
    end

    def ancestors
      @ancestors || ancestors!
    end
    
    def depth
      ancestors.length
    end
    
    def root!
      @root = root? ? self : parent.root!
    end

    def root
      @root || root!
    end
    
    def root?
      parent.nil?
    end
    
    
    module ClassMethods
      
      def attr_children(*arguments)
        arguments.flatten(1).each do |name|

          unless method_defined?(name) || method_defined?("#{name}!")
            define_method(name) do
              instance_variable_get("@#{name}") || send("#{name}!")
            end
          
            define_method("#{name}!") do
              instance_variable_set("@#{name}", find_children_by_name(name))
            end
          end
          
        end
      end
      
    end
  end
end