class WebhooksBaseController < ActionController::Base
  class UnauthorizedError < StandardError; end

  skip_forgery_protection

  rescue_from ::WebhooksBaseController::UnauthorizedError, with: :unauthorized_error_handler

  private

  def raise_not_authorized!(message = 'Not Authorized')
    raise ::WebhooksBaseController::UnauthorizedError.new(message)
  end

  def render_unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def unauthorized_error_handler(error)
    render_unauthorized
  end

  def send_error_to_tracker(error)
    # TODO: Send error to sentry or some other selected error tracker
    # ::Sentry.capture_exception(error) if ENV['SENTRY_DSN'] && ::Sentry.configuration.enabled_in_current_env?
  end
end
