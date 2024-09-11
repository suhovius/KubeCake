module Github
  class WebhooksController < ::WebhooksBaseController
    class InvalidSignature < StandardError; end

    rescue_from(
      ::ActiveRecord::RecordNotFound,
      InvalidSignature,
      with: :unauthorized_error_handler
    )

    # Ignore unknown webhooks silently (no errors) but notify them to error tracker
    rescue_from(
      ::Github::Webhooks::Processor::UnknownWebhookError,
    ) do |error|
      send_error_to_tracker(error)
      head :ok
    end

    def create
      verify_signature!

      ::Github::Webhooks::Processor.new(**processor_params).perform

      head :ok
    end

    private

    def decoded_raw_post
      @decoded_raw_post ||= ActiveSupport::JSON.decode(request.raw_post)
    end

    def processor_params
      # This fix for action is needed as Rails overrides is with controller action name create
      # while we need an original value here
      fixed_params = { action: decoded_raw_post['action'] }
      {
        params: params.permit!.to_h.merge(fixed_params),
        header_attrs:
      }
    end

    # INFO: Read about headers here
    # https://docs.github.com/en/webhooks/webhook-events-and-payloads#delivery-headers
    def header_attrs
      {
        event: request.env['HTTP_X_GITHUB_EVENT'],
        hook_installation_target_id: request.env['HTTP_X_GITHUB_HOOK_INSTALLATION_TARGET_ID'], # Github App ID
        hook_installation_target_type: request.env['HTTP_X_GITHUB_HOOK_INSTALLATION_TARGET_TYPE']
      }
    end

    def request_signature
      request.env['HTTP_X_HUB_SIGNATURE_256']
    end

    def calculate_signature
      [
        'sha256=',
        OpenSSL::HMAC.hexdigest(
          OpenSSL::Digest.new('sha256'),
          Rails.application.config.github_webhook_secret_token,
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
