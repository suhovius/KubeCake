# INFO: Read more here
# https://docs.github.com/en/webhooks/webhook-events-and-payloads?actionType=opened#pull_request
module Github
  module Webhooks
    module Handlers
      module PullRequest
      	class Changed < Base

      		def perform
            opts = { installation_id:, repo_full_name:, pull_number:, repo_id: }.stringify_keys

            ::Github::Repos::Pulls::Reviewers::OllamaAIJob.perform_later(**opts)
      		end

          private

          def installation_id
            @params.dig(:installation, :id)
          end

          def repo_full_name
            @params.dig(:pull_request, :base, :repo, :full_name)
          end

          def repo_id
            @params.dig(:pull_request, :base, :repo, :id)
          end

          def pull_number
            @params.dig(:pull_request, :number)
          end
      	end
      end
    end
  end
end