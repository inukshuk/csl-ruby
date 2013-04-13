
class Symbol
  include Comparable

  def <=>(other)
    return unless other.kind_of? Symbol
    to_s <=> other.to_s
  end
end unless Symbol.is_a?(Comparable)

class Module
  if RUBY_VERSION < '1.9'
    alias const? const_defined?
  else
    def const?(name)
      const_defined?(name, false)
    end
  end
end

class Struct
  alias_method :__class__, :class
end unless Struct.instance_methods.include?(:__class__)

module CSL
  module_function

  if RUBY_VERSION < '1.9'
    def encode_xml_attr(string)
      string.inspect
    end

    def encode_xml_text(string)
      string.dup
    end
  else
    def encode_xml_text(string)
      string.encode(:xml => :text)
    end

    def encode_xml_attr(string)
      string.encode(:xml => :attr)
    end
  end
end
