module Github
  module Webhooks
    class Processor
      class UnknownWebhookError < StandardError; end

      HANDLERS = {
        'installation.created' => ::Github::Webhooks::Handlers::Installation::Created,
        'installation.deleted' => ::Github::Webhooks::Handlers::Installation::Deleted,
        # TODO: Process other webhooks if needed
        # 'installation_repositories.added' => ::Github::Webhooks::Handlers::InstallationRepositories::Added,
        # 'installation.new_permissions_accepted' => ::Github::Webhooks::Handlers::Installation::NewPermissionsAccepted,
        # 'installation.suspend' => ::Github::Webhooks::Handlers::Installation::Suspend,
        # 'installation.unsuspend' => ::Github::Webhooks::Handlers::Installation::Unsuspend,
        # 'pull_request.opened' => ::Github::Webhooks::Handlers::PullRequest::Opened,
      }.freeze

      def initialize(params:, header_attrs:)
        @params = params
        @header_attrs = header_attrs
      end

      def perform
        raise_unknown_webhook_error! if handler.blank?

        process_webhook
      end

      private

      def hook_tag
        [@header_attrs[:event], @params['action']].join('.')
      end

      def handler
        @handler ||= HANDLERS[hook_tag]
      end

      def raise_unknown_webhook_error!
        message = ['Unknown webhook with params: ', @params.to_json, @header_attrs.to_json].join
        raise UnknownWebhookError.new(message)
      end

      def process_webhook
        handler.new(params: @params, header_attrs: @header_attrs).perform
      end
    end
  end
end
