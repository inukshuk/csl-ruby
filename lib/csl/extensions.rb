module CSL
  module Extensions
    # shamelessly copied from active_support
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
