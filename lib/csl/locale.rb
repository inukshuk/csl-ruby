module CSL
  #
  # CSL::Locales contain locale specific date formatting options, term
  # translations, and a number ordinalizer.
  #
  class Locale < Node
    types << CSL::Info

    include Comparable

    @default = 'en-US'.freeze

    @root = File.expand_path('../../../vendor/locales', __FILE__).freeze

    @extension = '.xml'.freeze
    @prefix = 'locales-'.freeze


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
      include Loader

      attr_accessor :default
      attr_reader :languages, :regions

      def parse(data)
        node = CSL.parse!(data, self)

        raise ParseError, "root node is not a locale: #{node.inspect}" unless
          node.is_a?(self)

        node
      end
    end

    attr_defaults :version => Schema.version, :xmlns => Schema.namespace
    attr_struct :xmlns, :version

    attr_children :'style-options', :info, :date, :terms

    attr_accessor :language, :region

    alias_child :metadata, :info
    alias_child :dates, :date
    alias_child :options, :style_options

    private :attributes
    undef_method :[]=

    # call-seq:
    #   Locale.new                                         -> default
    #   Locale.new('en')                                   -> American English
    #   Locale.new('en', :'punctuation-in-quote' => fales) -> with style-options
    #   Locale.new(:lang => 'en-GB', :version => '1.0')    -> British English
    #
    # Returns a new locale. In the first form, the language/regions is set
    # to the default language and region. In the second form the
    # language/region is set by the passed-in IETF tag. The third form
    # additionally accepts a hash of localize style-options. The fourth form
    # is the standard node attribute initialize signature.
    def initialize(*arguments)
      case arguments.length
      when 0
        locale, attributes, options = Locale.default, {}, nil
      when 1
        if arguments[0].is_a?(Hash)
          arguments[0] = arguments[0].symbolize_keys

          locale = arguments[0].delete(:lang) ||
            arguments[0].delete(:'xml:lang') || Locale.default

          attributes, options = arguments
        else
          attributes, locale, options = {}, arguments
        end
      when 2
        attributes, locale, options = {}, *arguments
      else
        raise ArgumentError, "wrong number of arguments (#{arguments.length} for 0..2)"
      end

      super(attributes, &nil)

      set(locale) unless locale.nil?

      unless options.nil?
        children[:'style-options'] = StyleOptions.new(options)
      end

      yield self if block_given?
    end

    # TODO
    # def initialize_copy(other)
    #   @options = other.options.dup
    # end


    def added_to(node)
      raise ValidationError, "not allowed to add locale to #{node.nodename}" unless
        node.nodename == 'style'
    end


    def version
      attributes[:version]
    end

    def version=(version)
      raise ArgumentError, "failed to set version to #{version}" unless
        version.respond_to?(:to_s)

      version = version.to_s.strip

      raise ArgumentError, "failed to set version to #{version}: not a version string" unless
        version =~ /^\d[\d\.]+$/

      if version > Schema.version
        warn "setting version to #{version}; latest supported version is #{Schema.version}"
      end

      attributes[:version] = version
    end

    # @return [Boolean] whether or not the Locale's version is less than CSL-Ruby's default version
    def legacy?
      version < Schema.version
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

    def translate(*arguments)
      raise 'not implemented'
    end

    alias _ translate
    alias t translate

    # call-seq:
    #   locale.each_term { |term| block } -> locale
    #   locale.each_term                  -> enumerator
    #
    # Calls block once for each term defined by the locale. If no block is
    # given, an enumerator is returned instead.
    def each_term
      if block_given?
        terms.each(&Proc.new)
        self
      else
        enum_for :each_term
      end
    end

    # call-seq:
    #   locale.each_date { |date_format| block } -> locale
    #   locale.each_date                         -> enumerator
    #
    # Calls block once for each date format defined by the locale. If no
    # block is given, an enumerator is returned instead.
    def each_date
      if block_given?
        date.each(&Proc.new)
      else
        enum_for :each_date
      end
    end

    # @returns [Boolean] whether or not the Locale is the default locale
    def default?
      to_s == Locale.default
    end

    # @return [Boolean] whehter or not the Locale's region is the default
    #   region for its language
    def default_region?
      region && region == Locale.regions[language]
    end

    # @return [Boolean] whether or not the Locale's language is the default
    #   language for its region
    def default_language?
      language && language == Locale.languages[region]
    end

    # Ordinalizes the passed-in number using either the ordinal or
    # long-ordinal forms defined by the locale. If a long-ordinal form is
    # requested but not available, the regular ordinal will be returned
    # instead.
    #
    # @example
    #   Locale.load('en').ordinalize(13)
    #   #-> "13th"
    #
    #   de = Locale.load('de')
    #   de.ordinalize(13)
    #   #-> "13."
    #
    #   de.ordinalize(3, :form => :long, :gender => :feminine)
    #   #-> "dritte"
    #
    # @note
    #   For CSL 1.0 (and older) locales that do not define an "ordinal-00"
    #   term the algorithm specified by CSL 1.0 is used; otherwise uses the
    #   CSL 1.0.1 algorithm with improved support for languages other than
    #   English.
    #
    # @param number [#to_i] the number to ordinalize
    # @param options [Hash] formatting options
    #
    # @option options [:short,:long] :form (:short) which ordinals form to use
    # @option options [:feminine,:masculine,:neutral] :gender (:neutral)
    #   which ordinals gender-form to use
    #
    # @raise [ArgumentError] if number cannot be converted to an integer
    #
    # @return [String] the ordinal for the passed-in number
    def ordinalize(number, options = {})
      raise ArgumentError, "unable to ordinalize #{number}; integer expected" unless
        number.respond_to?(:to_i)

      number, query = number.to_i, ordinalize_query_for(options)

      key = query[:name]

      # Try to match long-ordinals first
      if key.start_with?('l')
        query[:name] = key % number.abs
        ordinal = terms[query]

        if ordinal.nil?
          key = 'ordinal-%02d'
        else
          return ordinal.to_s(options)
        end
      end

      # CSL 1.0 (legacy algorithm)
      if legacy? || terms['ordinal-00'].nil?
        return legacy_ordinalize(number)
      end

      #
      # CSL 1.0.1
      #

      # Try to find direct match
      mod = 10 ** Math.log10([number.abs, 1].max).to_i
      query.merge! :name => key % number.abs

      ordinal = terms[query]

      # Try to match modulus of number, dividing mod by 10 at each
      # iteration until a match is found
      while ordinal.nil? && mod > 0
        query.merge! :name => key % (number.abs % mod)

        ordinal = terms[query]

        if ordinal && ordinal.attribute?(:modulo) && ordinal[:modulo] != mod.to_s
          ordinal = nil
        end

        mod = mod / 10
      end

      # If we have not found a match at this point, we try to match
      # the ordinal-00 gender neutral defintion
      if ordinal.nil? && query.key?(:'gender-form')
        query.delete(:'gender-form')
        ordinal = terms[query]
      end

      [number, ordinal.to_s(options)].join
    end

    def validate
      Schema.validate self
    end

    def valid?
      validate.empty?
    end

    # Locales are sorted first by language, then by region; sort order is
    # alphabetical with the following exceptions: the default locale is
    # prioritised; in case of a language match the default region of that
    # language will be prioritised (e.g., de-DE will come before de-AT even
    # though the alphabetical order would be different).
    #
    # @param other [Locale] the locale used for comparison
    # @return [1,0,-1,nil] the result of the comparison
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

    # @return [String] the Locale's IETF tag
    def to_s
      [language, region].compact.join('-')
    end

    # @return [String] a string representation of the Locale
    def inspect
      "#<#{self.class.name} #{to_s}>"
    end

    private

    def attribute_assignments
      if root?
        super.push('xml:lang="%s"' % to_s)
      else
        'xml:lang="%s"' % to_s
      end
    end

    def preamble
      Schema.preamble.dup
    end

    # @return [Hash] a valid ordinalize query; the name attribute is a format string
    def ordinalize_query_for(options)
      q = { :name => 'ordinal-%02d' }

      unless options.nil?
        if options.key?(:form) && options[:form].to_s =~ /^long(-ordinal)?$/i
          q[:name] = 'long-ordinal-%02d'
        end

        gender = (options[:'gender-form'] || options[:gender]).to_s
        unless gender.empty? || gender =~ /^n/i
          q[:'gender-form'] = (gender =~ /^m/i) ? 'masculine' : 'feminine'
        end
      end

      q
    end

    def legacy_ordinalize(number)
      case
      when (11..13).include?(number.abs % 100)
        [number, terms['ordinal-04']].join
      when (1..3).include?(number.abs % 10)
        [number, terms['ordinal-%02d' % (number.abs % 10)]].join
      else
        [number, terms['ordinal-04']].join
      end
    end
  end

end