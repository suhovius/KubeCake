module BaseApi
  module Errors
    class HttpVerbInvalid < StandardError
      attr_reader :http_verb

      def initialize(http_verb)
        @http_verb = http_verb

        super(error_message)
      end

      private

      def error_message
        # Using join to ensure that no any data is being interpolated
        # for safety reasons
        ["Http verb '", http_verb, "' is invalid"].join
      end
    end
  end
end

