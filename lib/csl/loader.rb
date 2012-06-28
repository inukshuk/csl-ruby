module CSL
  #
  # Mixin used by Locale and Style to load assets either from disk or from
  # the network. Classes including the Loader module are expected to provide
  # appropriate root, prefix and extension values and a parse method that
  # will be passed the contents of the asset data.
  #
  module Loader
    
    attr_accessor :root, :prefix, :extension
    
    # call-seq:
    #   Style.load(:apa)                         -> style
    #   Style.load('chicago-author.csl')         -> style
    #   Locale.load('en')                        -> locale
    #   Locale.load('http://example.com/de.xml') -> locale
    #
    # Resolves the passed-in path/name or string and loads the asset data.
    # The data will be passed on to the #parse method of the base class.
    # Typically, this will return a new instance of the class.
    def load(input)
      case
      when input.respond_to?(:read)
        data = input.read
      when input.to_s =~ /^\s*</
        data = input
      else

				case
				when File.exists?(input)
					location = input
				when File.exists?(extend_name(input))
					location = extend_name(input)
				when File.exists?(extend_path(input))
					location = extend_path(input)
				else
					location = input
				end

				Kernel.open(location, 'r:UTF-8') do |io|
          data = io.read
        end
      end

			parse(data)
			
		rescue => e
			raise ParseError, "failed to load #{input.inspect}: #{e.message}"
    end
    
    # Extends the passed-in string to a full path.
    def extend_path(string)
      File.join(root.to_s, extend_name(string))
    end
    
    # Extends the passed-in string to a style/locale name, by prefixing and
    # appending the default name prefix and extension.
    def extend_name(string)
      if File.extname(string).empty?
        name = [string, extension].compact.join
      else
        name = string.to_s.dup
      end
      
      unless name.start_with?(prefix.to_s)
        name = [prefix, name].join
      end
      
      name
    end

    # The base class is exepcted to redefine the #parse method.
    def parse(data)
      raise 'Not Implemented'
    end
  end
  
end