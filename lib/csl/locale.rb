module CSL
	#
	# CSL Locales contain locale specific date formatting options, term
	# translations, and number ordinalizations.
	#
	class Locale
		
		@defaults = {
			:'punctuation-in-quote' => true
		}.freeze
		
		class << self
			attr_reader :defaults
		end
		
		attr_reader :options, :language, :region
			
	end
end