module CSL
	
	module Metadata
		
		Contributor = Struct.new(:name, :email, :uri) do
			
			def initalize(attributes = {})
				super(*attributes.values_at(*members))
			end
			
			def nodename
			  self.class.name.split(/::/)[-1].downcase
			end
			      
      def content
				each_pair.map { |name, value|
					value ? "<#{name}>#{value}</#{name}>" : nil
				}.join
			end
			
			def to_xml
			  "<#{nodename}>#{content}</#{nodename}>"
      end
			
		end
		
		Author = Translator = Contributor
		
	end
	
end