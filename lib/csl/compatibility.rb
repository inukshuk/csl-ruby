
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
