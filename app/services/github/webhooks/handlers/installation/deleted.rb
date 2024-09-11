# INFO: Read more here
# https://docs.github.com/en/webhooks/webhook-events-and-payloads#installation
module Github
  module Webhooks
    module Handlers
      module Installation
      	class Deleted < Base

      		def perform
            uninstall_app
      		end

          private

          def installation_attrs
            @params['installation']
          end

          def uninstall_app
            attrs = installation_attrs
            installation = ::Github::Installation.find_or_initialize_by(external_id: attrs['id'])

            installation&.destroy
          end
      	end
      end
    end
  end
end