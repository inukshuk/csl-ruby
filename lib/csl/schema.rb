module CSL
  
  class Schema
    
    @version   = '1.0.1'.freeze
    @namespace = 'http://purl.org/net/xbiblio/csl'.freeze
    @preamble  = '<?xml version="1.0" encoding="utf-8"?>'.freeze
    
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
      :textcase => %w{
        lowercase uppercase capitalize-first capitalize-all title sentence
      },
      :date => %w{
        name form range-delimiter date-parts
      },
      :style => %w{
        demote-non-dropping-particle initialize-with-hyphen page-range-format
        names-delimiter
      },
      :citation => %w{
        cite-group-delimiter collapse year-suffix-delimiter
        after-collapse-delimiter disambiguate-add-names
        disambiguate-add-givenname disambiguate-add-year-suffix
        givenname-disambiguation-rule names-delimiter
      },
      :bibliography => %w{
        note-distance hanging-indent line-formatting second-field-align,
        subsequent-author-substitute subsequent-author-substitute-rule
        names-delimiter
      },
      :name => %w{
        name-form name-delimiter and delimiter-precedes-et-al
        delimiter-precedes-las et-al-min etal-use-first et-al-subsequent-min
        et-al-subsequent-use-first et-al-use-last initialize initialize-with
        name-as-sort-order sort-separator
      },
      :label => %w{
        plural
      },
      :text => %w{
        macro term form plural value form
      }
    })
    
    @attributes[:number] = @attributes.values_at(
      :affixes, :display, :font, :textcase).flatten

    @attributes[:names] = @attributes.values_at(
      :affixes, :display, :font, :delimiter).flatten

    @attributes[:group] = @attributes.values_at(
      :affixes, :display, :delimiter).flatten

    @attributes[:style]        += @attributes[:name]
    @attributes[:citation]     += @attributes[:name]
    @attributes[:bibliography] += @attributes[:name]

    @attributes[:text] += @attributes.values_at(
      :affixes, :display, :font, :quotes, :periods, :textcase).flatten
      
    @attributes[:label] += @attributes.values_at(
      :affixes, :font, :textcase, :periods).flatten

    @attributes[:date] += @attributes.values_at(
      :affixes, :display, :font, :textcase).flatten


    
    @attributes.each_value { |v| v.map!(&:to_sym).freeze }
    @attributes.freeze
    
    @terms = %w{ long verb short verb-short symbol }.map(&:to_sym).freeze

    @metadata = %w{
      author category contributor id issn eissn issnl link published rights
      summary title title-short updated translator
    }.map(&:to_sym).freeze
    
    
    class << self
      
      attr_accessor :version, :namespace, :types, :variables, :categories,
        :attributes, :terms, :preamble, :metadata
      
      private :new
      
      def attr(*arguments)
        attributes.values_at(*arguments).flatten(1)
      end
      
    end
    
  end
  
end