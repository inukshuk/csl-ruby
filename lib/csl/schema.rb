module CSL
  
  class Schema
    
    @version   = '1.0.1'.freeze
    @namespace = 'http://purl.org/net/xbiblio/csl'.freeze
    @preamble  = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n".freeze
    
    @types = %w{ article article-journal article-magazine article-newspaper
      bill book broadcast chapter entry entry-dictionary entry-encyclopedia
      figure graphic interview legal_case legislation manuscript map
      motion_picture musical_score pamphlet paper-conference patent
      personal_communication post post-weblog report review review-book song
      speech thesis treaty webpage }.map(&:to_sym).freeze

    @variables = Hash.new { |h,k| h.fetch(k.to_sym, nil) }.merge({
      :date => %w{
        accessed container event-date issued original-date submitted
      },

      :names => %w{
        author collection-editor composer container-author recipient editor
        editorial-director illustrator interviewer original-author translator
      },

      :number => %w{
        chapter-number collection-number edition issue number number-of-pages
        number-of-volumes volume        
      },

      :text => %w{
        abstract annote archive archive_location archive-place authority
        call-number citation-label citation-number collection-title
        container-title container-title-short dimensions DOI event event-place
        first-reference-note-number genre ISBN ISSN jurisdiction keyword
        locator medium note original-publisher original-publisher-place
        original-title page page-first PMID PMCID publisher publisher-place
        references section source status title title-short URL version
        year-suffix
      }
    })

    @variables.each_value { |v| v.map!(&:to_sym).freeze }

    @categories = Hash.new { |h,k| h.fetch(k.to_sym, nil) }.merge(
      Hash[*@variables.keys.map { |k| @variables[k].map { |n| [n,k] } }.flatten]
    ).freeze

    @variables[:name] = @variables[:names]
    @variables[:dates] = @variables[:date]
    @variables[:numbers] = @variables[:number]

    @variables[:all] = @variables[:any] =
      [:date,:names,:text,:number].reduce([]) { |s,a| s.concat(@variables[a]) }.sort

    @variables.freeze
    
    @attributes = Hash.new { |h,k| h.fetch(k.to_sym, nil) }.merge({
      :affixes => %w{
        prefix suffix
      },
      :delimiter => %w{
        delimiter
      },
      :display => %w{
        block left-margin right-inline indent
      },
      :font => %w{
        font-style font-variant font-weight text-decoration vertical-align
      },
      :quotes => %w{
        quotes
      },
      :periods => %w{
        strip-periods
      },
      :name => %w{
        name-form name-delimiter and delimiter-precedes-et-al initialize-with
        delimiter-precedes-last et-al-min et-al-use-first et-al-subsequent-min
        et-al-subsequent-use-first et-al-use-last name-as-sort-order
        sort-separator initialize
      },
      :names => %w{
        names-delimiter
      }
    })
    
    @attributes.each_value { |v| v.map!(&:to_sym).freeze }

		@attributes[:formatting] = [:'text-case'].concat(
			@attributes.values_at(:affixes, :font).flatten)

    @attributes.freeze
    
    @file = File.expand_path('../../../vendor/schema/csl.rng', __FILE__)
    
    @validators = {
      :nokogiri => lambda { |schema, style|
        schema.validate(Nokogiri::XML(style)).map { |e| [e.line, e.message] }
      },
      
      :default => lambda { |schema, style|
        raise ValidationError, "please `gem install nokogiri' for validation support"
      }
    }
    
    begin
      # TODO enable java validator when nokogiri issue is fixed
      if RUBY_PLATFORM =~ /java/i
        @validator = @validators[:default]
      else
        require 'nokogiri'
        @validator = @validators[:nokogiri]
        @schema = Nokogiri::XML::RelaxNG(File.open(@file, 'r:UTF-8'))
      end
    rescue LoadError
      @validator = @validators[:default]
    end
    
    class << self
      
      attr_accessor :version, :namespace, :types, :variables, :categories,
        :attributes, :preamble
      
      private :new
      
      def attr(*arguments)
        attributes.values_at(*arguments).flatten(1)
      end
      
      # Validates the passed-in style or list of styles. The style argument(s)
      # can either be a {Style} object, a style's file handle, XML content
      # or a valid location (wildcards are supported). The method returns
      # a list of validation errors; the passed-in style is valid if the
      # method returns an empty list.
      #
      # @example
      #   CSL::Schema.validate(CSL::Style.load(:apa))
      #
      #   CSL::Schema.validate('my-styles/style.csl')
      #   CSL::Schema.validate('my-styles/*.csl')
      #   CSL::Schema.validate('http://www.zotero.org/styles/vancouver')
      #
      # @param style [Node,String,IO,Array] the style (or a list of styles)
      #   to validate.
      #
      # @raise [ArgumentError] if the passed-in argument is not a Style or
      #   a valid style location.
      # @raise [ValidationError] if the validation process fails
      #
      # @return [<<Fixnum,String>>] a list of validation errors
      def validate(node)
        case
        when node.is_a?(Node)
          validator[schema, node.to_xml]
        when node.respond_to?(:read)
          validator[schema, node.read]
        when node.is_a?(Enumerable) && !node.is_a?(String)
          node.map { |n| validate(n) }.flatten(1)
        when node.respond_to?(:to_s)
          node = node.to_s

          case
          when node =~ /^\s*</
            validator[schema, node]
          when File.exists?(node)
            validator[schema, File.open(node, 'r:UTF-8')]
          else
            glob = Dir.glob(node)
            
            if glob.empty?
              validator[schema, Kernel.open(node)]            
            else
              glob.map { |n| validator[schema, File.open(n, 'r:UTF-8')] }.flatten(1)
            end
          end
        else
          raise ArgumentError, "failed to validate #{node.inspect}: not a CSL node"
        end
      end
      
      # Whether or not the passed-in style (or list of styles) is valid.
      #
      # @see validate
      #
      # @param style [Style,String,IO,Array] the style (or a list of styles)
      #   to validate.
      #
      # @raise [ArgumentError] if the passed-in argument is not a Style or
      #   a valid style location.
      # @raise [ValidationError] if the validation process fails
      #
      # @return [Boolean] whether or not the passed-in style (or styles)
      #   is valid.
      def valid?(style)
        validate(style).empty?
      end
      
      private
      
      attr_reader :validators, :validator, :schema
    end
    
  end  
end