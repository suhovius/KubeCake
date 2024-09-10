module Github
  module Webhooks
    class Processor
      class InvalidAuthTokenError < StandardError; end

      class UnknownWebhookError < StandardError; end

      # TODO Update this logic
      HANDLERS = {
        # 'pull_request' => ::Github::Webhooks::Handlers::PullRequest
      }.freeze

      def initialize(params:, auth_token:)
        @params = params
        @auth_token = auth_token
      end

      def perform
        # TODO: Update this logic

        # @github_config = find_github_config!

        # raise_unknown_webhook_error! if handler.blank?

        # authenticate!

        # process_webhook
      end

      private

      def find_github_config!
        ::Github::Config.find_by!(uuid: @params[:github_config_uuid])
      end

      def handler
        @handler ||= HANDLERS[@params['event']]
      end

      def event
        @params['event'] if handler.present?
      end

      def webhooks_auth_token
        auth_token_attr_name = [event, '_webhooks_auth_token'].join
        @github_config.public_send(auth_token_attr_name)
      end

      def authenticated?
        # Compare the tokens in a time-constant manner, to mitigate timing attacks.
        ::ActiveSupport::SecurityUtils.secure_compare(
          @auth_token, webhooks_auth_token
        )
      end

      def authenticate!
        return if authenticated?

        message = ["Auth Token '", @auth_token, "' is not valid"].join

        raise InvalidAuthTokenError.new(message)
      end

      def raise_unknown_webhook_error!
        message = ['Unknown webhook with params: ', @params.to_json].join
        raise UnknownWebhookError.new(message)
      end

      def process_webhook
        handler.new(params: @params, github_config: @github_config).perform
      end
    end
  end
end
