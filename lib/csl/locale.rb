
require 'csl/locale/metadata'
require 'csl/locale/date'
require 'csl/locale/term'

module CSL
	#
	# CSL Locales contain locale specific date formatting options, term
	# translations, and a number ordinalizer.
	#
	class Locale		
		
		include Comparable
		include Enumerable
		
    @default = 'en-US'.freeze

		@root = File.expand_path('../../../vendor/locales', __FILE__).freeze
		    
		@extension = '.xml'.freeze
		@prefix = 'locales-'.freeze
		
		@options = {
			:'punctuation-in-quote' => true
		}.freeze

    
		# Default languages/regions.
		# Auto-detection is based on these lists.
		@regions = Hash[*%w{
		  af ZA ar AR bg BG ca AD cs CZ da DK de DE el GR en US es ES et EE fa IR
		  fr FR he IL hu HU is IS it IT ja JP km KH ko KR mn MN nb NO nl NL nn NO
		  pl PL pt PT ro RO ru RU sk SK sl SI sr RS sv SE th TH tr TR uk UA vi VN
		  zh CN zh TW
		}.map(&:to_sym)].freeze

		@languages = @regions.invert.merge(Hash[*%w{
		  AT de BR pt CA en CH de GB en
		}.map(&:to_sym)]).freeze
		
		
		class << self
			extend Loader
			
			attr_accessor :default, :options
			attr_reader :languages, :regions
			
			def parse(data)
			end
			
		end
		
		attr_reader :options, :terms, :dates, :metadata
		attr_accessor :language, :region

		alias info metadata
		
		def initialize(locale = Locale.default, options = {})
		  @options = Locale.options.merge(options)
		  @terms, @dates = [], []
		
		  set(locale) unless locale.nil?
		
			yield self if block_given?
		end
		
		def initialize_copy(other)
			@options = other.options.dup			
			@dates = other.dates.map(&:dup)
			@terms = other.terms.map(&:dup)
		end
		
		# call-seq:
		#   locale.set('en')    -> sets language to :en, region to :US
		#   locale.set('de-AT') -> sets language to :de, region to :AT
		#   locale.set('-DE')   -> sets langauge to :de, region to :DE
		#
		# Sets language and region according to the passed-in locale string. If
		# the region part is not defined by the string, this method will set the
		# region to the default region for the given language.
		#
		# Raises ArgumentError if the argument is no valid locale string. A valid
		# locale string is based on the syntax of IETF language tags; it consists
		# of either a language or region tag (or both), separated by a hyphen.
		def set(locale)
		  language, region = locale.to_s.scan(/([a-z]{2})?(?:-([A-Z]{2}))?/)[0].map do |tag|
				tag.respond_to?(:to_sym) ? tag.to_sym : nil
			end
		  
		  case
		  when language && region
		    @language, @region = language, region
		  when language
		    @language, @region = language, Locale.regions[language]
		  when region
		    @language, @region = Locale.languages[region], region
		  else
		    raise ArgumentError, "not a valid locale string: #{locale.inspect}"
		  end
		  
		  self
		end
		
		# Sets the locale's language and region to nil.
		def clear
		  @language, @region = nil
		  self
		end
		
		# call-seq:
		#   locale.each      { |term| block } -> locale
		#   locale.each_term { |term| block } -> locale
		#   locale.each                       -> enumerator
		#   locale.each_term                  -> enumerator
		#
		# Calls block once for each term defined by the locale. If no block is
		# given, an enumerator is returned instead.
		def each_term
			if block_given?
				terms.values.each(&Proc.new)
				self
			else
				enum_for(:each_term)
			end
		end
		
		alias each each_term
		
		# call-seq:
		#   locale.each_date { |date_format| block } -> locale
		#   locale.each_date                         -> enumerator
		#
		# Calls block once for each date format defined by the locale. If no
		# block is given, an enumerator is returned instead.
		def each_date
			if block_given?
				dates.values.each(&Proc.new)
			else
				enum_for(:each_date)
			end
		end
		
		# Returns true if the Locale is the default locale.
		def default?
		  to_s == Locale.default
		end
		
		# Returns true if the Locale's region is the default region for its language.
		def default_region?
		  region && region == Locale.regions[language]
		end

		# Returns true if the Locale's language is the default language for its region.
		def default_language?
		  language && language == Locale.languages[region]
		end
				
		def ordinalize(integer)
			raise 'Not Implemented'
		end
		
		# Locales are sorted first by language, then by region; sort order is
    # alphabetical with the following exceptions: the default locale is
    # prioritised; in case of a language match the default region of that
    # language will be prioritised (e.g., de-DE will come before de-AT even
    # though the alphabetical order would be different).
		def <=>(other)
      case
			when !other.is_a?(Locale)
				nil
      when [language, region] == [other.language, other.region]
        0
      when default?
        -1
      when other.default?
        1
      when language == other.language
        case
        when default_region?
          -1
        when other.default_region?
          1
        else
          region <=> other.region
        end
      else
        language <=> other.language
      end
		end
		
		def nodename
		  'locale'
		end
		
		def to_xml
		  "<#{nodename}"
		end
		
		def content
		end
		
		def to_s
		  [language, region].compact.join('-')
		end
		
		def inspect
		  "#<#{self.class.name} #{to_s}: dates=[#{dates.length}] terms=[#{terms.length}]>"
		end
		
		private
		
		def attribute_list
		  ' xml:lang="%s"' % to_s
		end
		
	end
end