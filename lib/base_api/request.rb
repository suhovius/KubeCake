module BaseApi
  class Request
    HTTP_VERBS = %i[get head delete trace post put patch].freeze

    HTTP_VERBS_WITH_BODY = %i[post put patch].freeze

    ERROR_RESPONSE_STATUS_CODE_CATEGORY_NUMBERS = %w[4 5].freeze

    REDIRECT_RESPONSE_STATUS_CODE_CATEGORY_NUMBER = "3".freeze

    DEFAULT_OPTIONS =  {
      process_response_body: true,
      raise_error_on_redirect: true,
      trailing_slash: false,
      supported_content_types: []
    }.freeze

    # INFO: This method can be overriden in the descendants
    # to have more data provided to the api connection here
    # for example auth tokens, api keys, etc
    def initialize(base_url:, headers: {}, options: {}, params: {})
      base_url = format_base_url(base_url)

      @options = DEFAULT_OPTIONS.merge(options)
      @connection = prepare_connection(
        base_url: base_url, headers: headers, params: params
      )
    end

    def run_request(verb:, path:, data: {})
      @response = nil # clear previous response might be useful to debug issues

      validate_http_verb!(verb)

      path = format_path(path)

      payload = data.merge(connection.params)

      @response = connection.public_send(verb, path) do |request|
        assign_payload(verb: verb, request: request, payload: payload)
      end

      if options[:process_response_body]
        process_response
      else
        @response
      end
    end

    # INFO: This method is public for purpose of accessing the response object
    # if it is needed
    attr_reader :response

    class << self
      def format_response_body_for(response)
        resp_body = response.body
        if response.env.response_headers['content-encoding'] == 'gzip'
         resp_body = Zlib::GzipReader.new(StringIO.new(resp_body)).read
        end

        resp_body
      end
    end

    private

    attr_reader :connection, :options

    def format_base_url(url)
      URI.parse(url).tap { |uri| uri.path = '' }.to_s
    end

    def prepare_connection(base_url:, headers: {}, params: {})
      ::Faraday.new(
        url: base_url,
        headers: headers,
        params: params
      ).tap do |builder|
        builder.response(:logger) if options[:use_logger]
      end
    end

    def format_path(path)
      path = path + '/' if options[:trailing_slash] && path[-1] != '/'

      path
    end

    def process_response
      # Stop processing if response is error
      raise_error! if error?

      unexpected_redirect_error! if redirect? && options[:raise_error_on_redirect]

      validate_content_type!

      resp_body = response_body

      if content_type_includes?('application/json')
        # No any errors, so we can parse the JSON response to hash
        resp_body = ::ActiveSupport::JSON.decode(resp_body)
      end

      resp_body
    end

    def response_status_code_category_number(response)
      response.status.to_s[0]
    end

    def error?
      ERROR_RESPONSE_STATUS_CODE_CATEGORY_NUMBERS.include?(
        response_status_code_category_number(response)
      )
    end

    def redirect?
      response_status_code_category_number(response) ==
        REDIRECT_RESPONSE_STATUS_CODE_CATEGORY_NUMBER
    end

    def raise_error!
      raise ::BaseApi::Errors::Response.new(response)
    end

    def unexpected_redirect_error!
      raise ::BaseApi::Errors::UnexpectedRedirect.new(response)
    end

    def validate_http_verb!(verb)
      return if HTTP_VERBS.include?(verb.to_sym)

      raise ::BaseApi::Errors::HttpVerbInvalid.new(verb)
    end

    def assign_payload(verb:, request:, payload:)
      return unless payload.present?

      if HTTP_VERBS_WITH_BODY.include?(verb.to_sym)
        request.body = payload.to_json
      else
        request.params = payload
      end
    end

    def response_body
      self.class.format_response_body_for(response)
    end

    def content_type
      response.env.response_headers['content-type']
    end

    def content_type_includes?(expcted_content_type)
      content_type.include?(expcted_content_type)
    end

    def validate_content_type!
      # Skip validation if there is noa any restrictions
      return if options[:supported_content_types].empty?

      return if options[:supported_content_types].any? { |c_type| content_type_includes?(c_type) }

      raise ::BaseApi::Errors::NotSupportedContentType.new(content_type)
    end
  end
end
