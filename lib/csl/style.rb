module CSL

  class Style < Node
    types << CSL::Info << CSL::Locale

    @default = :apa

    @root = File.expand_path('../../../vendor/styles', __FILE__).freeze

    @extension = '.csl'.freeze
    @prefix = ''

    class << self
      include Loader

      attr_accessor :default

      def parse(data)
        node = CSL.parse!(data, self)

        raise ParseError, "root node is not a style: #{node.inspect}" unless
          node.is_a?(self)

        node
      end
    end

    attr_defaults :version => Schema.version, :xmlns => Schema.namespace

    attr_struct :xmlns, :version, :class, :'default-locale',
      :'initialize-with-hyphen', :'page-range-format',
      :'demote-non-dropping-particle', *Schema.attr(:name, :names)

    attr_children :'style-options', :info, :locale, :macro,
      :citation, :bibliography

    alias options  style_options
    alias locales  locale

    def_delegators :info, :self_link, :self_link=, :has_self_link?,
      :template_link, :template_link=, :has_template_link?,
      :documentation_link, :documentation_link=, :has_documentation_link?,
      :independent_parent_link, :independent_parent_link=,
      :has_independent_parent_link?, :title=, :id=, :has_title?, :has_id?

    def initialize(attributes = {})
      super(attributes, &nil)
      children[:locale], children[:macro] = [], []

      yield self if block_given?
    end

    def validate
      Schema.validate self
    end

    def valid?
      validate.empty?
    end

    def info
      children[:info] ||= Info.new
    end

    alias_child :metadata, :info

    # @return [String] the style's id
		def id
			return nil unless info.has_id?
			info.id.to_s
		end

    # @return [String] the style's title
		def title
			return nil unless info.has_title?
			info.title.to_s
		end

		# @return [Time] timestamp for the time set in info.updated
		def updated_at
			return nil unless info.has_updated?
			Time.parse(info.updated)
		end

    alias has_template? has_template_link?

    # @return [Style] the style's template
    def template
      return unless has_template?
      load_related_style_from template_link
    end

    alias dependent? has_independent_parent_link?
    
    def independent?
      !dependent?
    end
    
    def independent_parent
      return unless dependent?
      load_related_style_from independent_parent_link
    end
    
    private

    def preamble
      Schema.preamble.dup
    end
    
    def load_related_style_from(uri)
      # TODO try local first
      Style.load(uri)
    end
  end

end