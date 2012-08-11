module CSL
  class Locale
    
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
      return legacy_ordinalize(number) if legacy?

      #
      # CSL 1.0.1
      #

      # Calculate initial modulus
      mod = 10 ** Math.log10([number.abs, 1].max).to_i

      # Try to find direct match first
      query.merge! :name => key % number.abs
      ordinal = terms[query]

      # Try to match modulus of number, dividing mod by 10 at each
      # iteration until a match is found
      while ordinal.nil? && mod > 1
        query.merge! :name => key % (number.abs % mod)        
        ordinal = terms.lookup_modulo(query, mod)

        mod = mod / 10
      end

      # If we have not found a match at this point, we try to match
      # the default ordinal instead
      if ordinal.nil?
        query[:name] = 'ordinal'
        ordinal = terms[query]
        
        if ordinal.nil? && query.key?(:'gender-form')
          query.delete(:'gender-form')
          ordinal = terms[query]
        end
      end
      
      if ordinal.nil?
        number.to_s
      else
        [number, ordinal.to_s(options)].join
      end
    end
    
    private
    
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
