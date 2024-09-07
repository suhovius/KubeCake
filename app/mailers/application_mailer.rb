class ApplicationMailer < ActionMailer::Base
  default from: ::Rails.application.config.default_from_email
  layout 'mailer'
end
