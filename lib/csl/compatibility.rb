module CSL
  module_function

  def silence_warnings
    original_verbosity, $VERBOSE = $VERBOSE, nil
    yield
  ensure
    $VERBOSE = original_verbosity
  end
end

class Module
  def const?(name)
    const_defined?(name, false)
  end
end

class Struct
  alias_method :__class__, :class
end unless Struct.instance_methods.include?(:__class__)

module CSL
  module_function

  def encode_xml_text(string)
    string.encode(string.encoding, :xml => :text)
  end

  def encode_xml_attr(string)
    string.encode(string.encoding, :xml => :attr)
  end
end
