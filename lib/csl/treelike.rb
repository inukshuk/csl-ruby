module CSL
  
  module Treelike
    
    attr_accessor :parent
    attr_reader :children
    attr_writer :nodename
    
		protected :parent=
		
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    # @eturn [String] the node's name.
    def nodename
      @nodename ||= self.class.name.split(/::/)[-1].gsub(/([[:lower:]])([[:upper:]])/, '\1-\2').downcase
    end

    def each_child
      if block_given?
        children.each(&Proc.new)
        self
      else
        enum_for :each_child
      end
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
    rescue => e
      # TODO rollback
      raise e
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
    rescue => e
      # TODO rollback
      raise e
    end
    
    def <<(node)
      add_child node
      self
    end
    
    # Returns the first immediate child node whose nodename matches the
    # passed-in name or pattern; returns nil there is no match.
    def find_child_by_name(name)
      children.detect do |child|
        name === child.nodename
      end
    end
    alias > find_child_by_name
    
    # Returns all immediate child nodes whose nodename matches the passed-in
    # name or pattern; returns an empty array if there is no match.
    def find_children_by_name(name)
      children.select do |child|
        name === child.nodename
      end
    end
    alias >> find_children_by_name

    # Returns true if the node has child nodes; false otherwise.
    def has_children?
      !empty?
    end

		def empty?
			children.empty?
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
    
    # Returns this node's ancestors as an array.
    def ancestors
      @ancestors = each_ancestor.to_a
    end
    
    # Returns the node's current depth in the tree.
    def depth
      @depth = ancestors.length
    end
    
    # Returns the root node.
    def root
      @root = root? ? self : parent.root!
    end
    
    # Returns true if the node is a root node, or false.
    def root?
      parent.nil?
    end

		
    # Add memoized methods. When processing citations, styles will
		# typically remain stable; therefore cite processors may opt
		# to use memoized versions of the following methods. These
		# versions are marked with an exclamation mark as a reminder
		# that the return values are cached and potentially outdated.
    %w{ ancestors descendants siblings root depth }.each do |name|
      ivar = "@#{name}"
      define_method("#{name}!") do
        instance_variable_get(ivar) || send(name)
      end
    end
    
    protected
    
    # @abstract
    # Called after the node was added to another node.
    def added_to(node)
    end
    
    # @abstract
    # Called when the node was deleted from an other node.
    def deleted_from(node)
    end
    
    private
    
    # @abstract
    # Called when the passed-in node was added to this node as a child.
    def added_child(node)
    end
    
    # @abstract
    # Called when the passed-in node was deleted from this node's child nodes.
    def deleted_child(node)
    end
    

    module ClassMethods
      
      # Returns a new instance of an Array or Struct to manage the Node's
      # children. This method is called automatically by the Node's
      # constructor.
      def create_children
        if const?(:Children)
          const_get(:Children).new
        else
          []
        end
      end
      
			def constantize_nodename(name)
        klass = name.to_s.capitalize.gsub(/(\w)-(\w)/) { [$1, $2.upcase].join }
				
				case
				when respond_to?(:constantize)
					constantize(klass)
				when const_defined?(klass)
					const_get(klass)
				else
					nil
				end
			end
			
			
      private
      
      # Creates a Struct for the passed-in child node names that will be
      # used internally by the Node to manage its children. The Struct
      # will be automatically initialized and is used similarly to the
      # standard Array that normally holds the child nodes. The benefit of
      # using the Struct is that all child nodes are accessible by name and
      # need not be looked up; this improves performance, however, note that
      # a node defining it's children that way can only contain nodes of the
      # given types.
      #
      # This method also generates accessors for each child.
      def attr_children(*names)
        
        names.each do |name|
          name   = name.to_sym
          reader = name.to_s.downcase.tr('-', '_')
          writer = "set_child_#{reader}"
          

          define_method(reader) do
            children[name]
          end unless method_defined?(reader)

          unless method_defined?(writer)
            define_method(writer) do |value|
              begin
                klass = self.class.constantize_nodename(name)
								
                if klass
                  value = klass.new(value)
                else
                	# try to force convert value
                	value = (value.is_a?(String) ? TextNode : Node).new(value)
                	value.nodename = name.to_s
                end
                
              rescue => e
                raise ArgumentError, "failed to convert #{value.inspect} to node: #{e.message}"
              end unless value.respond_to?(:nodename)

              children << value
            end
            
            alias_method :"#{reader}=", writer
            
          end
        end
        
        const_set(:Children, Struct.new(*names) {
          
          # 1.8 Compatibility
          @keys = members.map(&:to_sym).freeze
          
          class << self
            attr_reader :keys
          end
                    
          def initialize(attrs = {})
            super(*attrs.symbolize_keys.values_at(*keys))
          end

          # @return [<Symbol>] a list of symbols representing the names/keys
          #   of the attribute variables.
          def keys
            self.class.keys
          end
          
          alias original_each each
          
          # Iterates through all children. Nil values are skipped and Arrays
          # expanded.
          def each
            if block_given?
              original_each do |node|
                if node.kind_of?(Array)
                  node.select { |n| !n.nil? }.each(&Proc.new)
                else
                  yield node unless node.nil?
                end
              end
            else
              to_enum
            end
          end
          
          def empty?
            all?(&:nil?)
          end
          
          # Adds the node as a child node. Raises ValidationError if none
          # of the Struct members matches the node's name. If there is
          # already a node set with this node name, the node will be pushed
          # to an array for that name.
          def push(node)
            unless node.respond_to?(:nodename) && keys.include?(node.nodename.to_sym)
              raise ValidationError, "not allowed to add #{node.inspect} to #{inspect}"
            end
            
            current = self[node.nodename]
            case current
            when Array
              current.push(node)
            when nil
              self[node.nodename] = node
            else
              self[node.nodename] = [current, node]
            end
            
            self
          end
          
          alias << push
          
          # Delete items from self that are equal to node. If any items are
          # found, returns the deleted items. If the items is not found,
          # returns nil. If the optional code block is given, returns the
          # result og block if the item is not found.
          def delete(node)
            return nil unless node.respond_to?(:nodename)
            
            deleted = resolve(node.nodename)
            if deleted.kind_of?(Array)
              deleted = deleted.delete(node)
            else
              if deleted == node
                self[node.nodename] = nil
              else
                deleted = nil
              end
            end
            
            if deleted.nil? && block_given?
              yield
            else
              deleted
            end
          end
          
          def fetch(name, default = nil)
            if block_given? 
              resolve(name) || yield(key)
            else
              resolve(name) || default
            end
          end
          
          private
          
          def resolve(nodename)
            keys.include?(nodename.to_sym) && send(nodename)
          end
        })
      end
      
      # Turns the Node into a leaf-node.
      def has_no_children   
        undef_method :add_child
        undef_method :added_child
        undef_method :add_children
        undef_method :<<

        undef_method :delete_child
        undef_method :deleted_child
        undef_method :delete_children
        
        private :children
        
        define_method(:has_children?) do
          false
        end

      end
            
    end
        
  end
end