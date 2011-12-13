module CSL
  
  module Treelike
    
    attr_accessor :parent
    attr_writer :nodename
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    # Returns the node's name.
    def nodename
      @nodename ||= self.class.name.split(/::/)[-1].gsub(/([[:lower:]])([[:upper:]])/, '\1-\2').downcase
    end
    
    # Returns the array of child nodes.
    def children
      @children ||= []
    end
    
    def each_child
      if block_given?
        children.each(&Proc.new)
        self
      else
        enum_for :each_child
      end
    end
    
    # Called after the node was added to another node.
    def added_to(node)
    end
    
    # Called when the node was deleted from an other node.
    def deleted_from(node)
    end
    
    # Called when the passed-in node was added to this node as a child.
    def added_child(node)
    end
    
    # Called when the passed-in node was deleted from this node's child nodes.
    def deleted_child(node)
    end
    
    def delete_children(*nodes)
      nodes.each do |node|
        delete_child node
      end
    end
    
    # Deletes child nodes that are equal to the passed-in node. Returns all
    # deleted children. If no children were deleted, returns nil. If the
    # optional block is given, returns the result block if no children were
    # deleted.
    def delete_child(child)
      deleted = children.delete child
      
      case
      when deleted.nil? && block_given?
        yield
      when deleted.nil?
        nil
      else
        [*deleted].each do |node|
          node.parent = nil
          
          deleted_child node
          node.deleted_from self
        end
        
        deleted
      end
    end
    
    def add_children(*nodes)
      nodes.each do |node|
        add_child node
      end
    end
    
    def add_child(node)
      node.unlink
      
      node.parent = self
      children << node
      
      added_child node
      node.added_to self
      
      node
    end
    
    def <<(node)
      add_child node
      self
    end
    
    # Returns all immediate child nodes whose nodename matches the passed-in
    # name or pattern; returns an empty array if there is no match.
    def find_children_by_name(name)
      children.select do |child|
        name === child.nodename
      end
    end
    alias > find_children_by_name

    # Returns true if the node has child nodes; false otherwise.
    def has_children?
      !children.empty?
    end
    
    # Unlinks the node and all its children from its parent node. Returns
    # the old parent node or nil.
    def unlink
      return nil if root?
      
      other = parent
      other.delete_child self
      
      self.parent = nil

      other
    end
    
    def each_sibling
      if block_given?
        unless root?
          parent.children.each do |node|
            yield node unless node.equal?(self)
          end
        end
        
        self
      else
        enum_for :each_sibling
      end
    end
    
    def siblings
      @siblings = each_sibling.to_a
    end
    
    
    def each_descendant
      if block_given?
        each_child do |child|
          yield child          
          child.each_descendant(&Proc.new)
        end
        
        self
      else
        enum_for :each_descendant
      end
    end
    
    # Returns all descendants of the node. See #descendants1 for a memoized
    # version.
    def descendants
      @descendants = each_descendant.to_a
    end
    
    def each_ancestor
      if block_given?
        p = parent
        
        until p.nil?
          yield p
          p = p.parent
        end
        
        self
      else
        enum_for :each_ancestor
      end
    end
    
    def ancestors
      @ancestors = each_ancestor.to_a
    end
    
    # Returns the depth of the node in the tree.
    def depth
      @depth = ancestors.length
    end
        
    def root
      @root = root? ? self : parent.root!
    end
    
    # Returns true if the node is a root node, or false.
    def root?
      parent.nil?
    end

    # Returns the current node and its subtree as a nested array.
    def to_ast
      [self, children.map(&:to_a)]
    end

    # Add memoized methods
    %w{ ancestors descendants siblings root depth }.each do |name|
      ivar = "@#{name}"
      define_method("#{name}!") do
        instance_variable_get(ivar) || send(name)
      end
    end
    
    module ClassMethods
      
      def attr_children(*arguments)
        arguments.each do |name|          
          unless method_defined?(name)
            ivar = "@#{name}"            
            define_method(name) do
              instance_variable_set(ivar, find_children_by_name(name))
            end
          end
        end
      end
      
    end
        
  end
end