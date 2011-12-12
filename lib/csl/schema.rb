module CSL
  
  class Schema
    
    @version   = '1.0.1'.freeze
    @namespace = 'http://purl.org/net/xbiblio/csl'.freeze
    
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
        form range-delimiter
      }
    })

    @attributes.each_value { |v| v.map!(&:to_sym).freeze }
    @attributes.freeze
    
    class << self
      
      attr_accessor :version, :namespace, :types, :variables, :categories,
        :attributes
      
      private :new
      
      def attr(*arguments)
        attributes.values_at(*arguments).flatten(1)
      end
      
    end
    
  end
  
end