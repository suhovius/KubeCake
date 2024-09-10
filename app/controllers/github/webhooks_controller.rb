# WIP: Needs to be done. This is just a template
module Github
  class WebhooksController < ::WebhooksBaseController
    class InvalidSignature < StandardError; end

    rescue_from(
      ::ActiveRecord::RecordNotFound,
      InvalidSignature,
      with: :unauthorized_error_handler
    )

    # Ignore unknown webhooks and metrics but notify them to sentry
    rescue_from(
      ::Github::Webhooks::Processor::UnknownWebhookError,
    ) do |error|
      send_error_to_tracker(error)
      head :ok
    end

    def create
      ::Github::Webhooks::Processor.perform(
        params: params.permit!.to_h
      )

      head :ok
    end

    private

    def request_signature
      request.env['HTTP_X_HUB_SIGNATURE_256']
    end

    def calculate_signature
      [
        'sha256=',
        OpenSSL::HMAC.hexdigest(
          OpenSSL::Digest.new('sha256'),
          ENV['GITHUB_WEBHOOK_SECRET_TOKEN'],
          request.raw_post
        )
      ].join
    end

    def verify_signature!
      return if Rack::Utils.secure_compare(calculate_signature, request_signature)

      raise InvalidSignature
    end
  end
end
