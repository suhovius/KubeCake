module BaseApi
  module Errors
    class UnexpectedRedirect < StandardError
      attr_reader :status, :location

      def initialize(response)
        @status = response.status
        @location = response.env.response_headers['location']

        super(error_message)
      end

      private

      def error_message
        # Using join to ensure that no any data is being interpolated
        # for safety reasons
        opts = ["Unexpeced Redirect: Status '", status, "'"]

        if location
          opts += [' ', "Location '", location, "'"]
        end

        opts.join
      end
    end
  end
end

