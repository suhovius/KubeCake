# INFO: Read more here
# https://docs.github.com/en/webhooks/webhook-events-and-payloads#installation
module Github
  module Webhooks
    module Handlers
      module Installation
      	class Created < Base
          ACCOUNT_ATTR_NAMES = %w[node_id login html_url avatar_url site_admin].freeze
          INSTALLATION_ATTR_NAMES = %w[client_id repository_selection html_url app_slug permissions events].freeze
          REPOSITORY_ATTR_NAMES = %w[node_id name full_name private].freeze

      		def perform
            installation = sync_installation
            repositories = sync_repositories
            installation.repositories = repositories
            installation
      		end

          private

          def installation_attrs
            @params['installation']
          end

          def sync_account
            attrs = installation_attrs['account']

            ::Github::Account
              .find_or_initialize_by(external_id: attrs['id']).tap do |account|
                account.entity_type = attrs['type']
                account.assign_attributes(attrs.slice(*ACCOUNT_ATTR_NAMES))
                account.save!
              end
          end

          def sync_installation
            attrs = installation_attrs

            ::Github::Installation
              .find_or_initialize_by(external_id: attrs['id']).tap do |installation|
                installation.account = sync_account
                installation.external_app_id = attrs['app_id']
                installation.assign_attributes(attrs.slice(*INSTALLATION_ATTR_NAMES))
                installation.save!
              end
          end

          def prompts_to_assign
            AI::CodeReview::Prompt.practical
          end

          def sync_repositories
            @params['repositories'].map do |attrs|
              ::Github::Repository
                .find_or_initialize_by(external_id: attrs['id']).tap do |repo|
                  should_assign_prompts = repo.new_record?

                  repo.assign_attributes(attrs.slice(*REPOSITORY_ATTR_NAMES))
                  repo.save!

                  repo.ai_code_review_prompts = prompts_to_assign if should_assign_prompts
                end
            end
          end
      	end
      end
    end
  end
end