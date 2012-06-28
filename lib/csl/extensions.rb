
# Some methods in this file are taken from ActiveSupport
# and are copyright (c) 2005-2010 David Heinemeier Hansson.
# They are loaded only if ActiveSupport is not present.

module CSL
  module Extensions

    module SymbolizeKeys
      def symbolize_keys
        inject({}) do |options, (key, value)|
          options[(key.to_sym rescue key) || key] = value
          options
        end
      end
  
      def symbolize_keys!
        replace(symbolize_keys)
      end

    end

    module StringifyKeys
      def stringify_keys
        inject({}) do |options, (key, value)|
          options[(key.to_s rescue key) || key] = value
          options
        end
      end

      def stringify_keys!
        replace(symbolize_keys)
      end
    end

		module Nesting
			def nesting
				name.split(/::/).inject([]) { |ns, n| ns << (ns[-1] || Object).const_get(n) }
			end
		end

  end
end

class Hash
  include CSL::Extensions::SymbolizeKeys unless method_defined?(:symbolize_keys)
  include CSL::Extensions::StringifyKeys unless method_defined?(:stringify_keys)
end

class Module
	include CSL::Extensions::Nesting
end
