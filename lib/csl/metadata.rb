module CSL
	
	module Metadata
		
		Contributor = Struct.new(:name, :email, :uri) do
			
			def initalize(attributes = {})
				super(*attributes.values_at(*members))
			end
			
			def to_xml
				each_pair.map { |name, value|
					value ? "<#{name}>#{value}</#{name}>" : nil
				}.join
			end
		end
		
		Author = Translator = Contributor
		
	end
	
end