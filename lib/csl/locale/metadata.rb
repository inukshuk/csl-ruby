module CSL
  class Locale
    
    Metadata = Struct.new(:translators, :rights, :updated) do
			
			def initialize(attributes = {})
				super attributes.fetch(:translators, []).map { |t| Translator.new(t) },
					*attributes.values_at(:rights, :updated)
			end
			
		end
		
	end
end