module BaseApi
  module Errors
    class NotSupportedContentType < StandardError
      attr_reader :content_type

      def initialize(content_type)
        @content_type = content_type

        super(error_message)
      end

      private

      def error_message
        # Using join to ensure that no any data is being interpolated
        # for safety reasons
        ["Content Type '", content_type, "' is not supported"].join
      end
    end
  end
end

