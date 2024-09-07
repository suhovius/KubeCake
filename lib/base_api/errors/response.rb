module BaseApi
  module Errors
    class Response < StandardError
      attr_reader :body, :response

      delegate :status, to: :response

      def initialize(response)
        @response = response
        @body = ::BaseApi::Request.format_response_body_for(response)

        super(error_message)
      end

      private

      def error_message
        # Using join to ensure that no any data is being interpolated
        # for safety reasons
        ["Status '", status, "'",' ', "Body '", body, "'"].join
      end
    end
  end
end

