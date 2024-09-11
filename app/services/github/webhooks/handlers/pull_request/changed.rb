# INFO: Read more here
# https://docs.github.com/en/webhooks/webhook-events-and-payloads?actionType=opened#pull_request
module Github
  module Webhooks
    module Handlers
      module PullRequest
      	class Changed < Base

      		def perform
            # TODO: This must be done in the background job
            apply_ai_ollama_review
      		end

          private

          def apply_ai_ollama_review
            ::Github::Repos::Pulls::Reviewers::AI::Ollama.new(
              octokit:, repo_full_name:, pull_number:
            ).perform
          end

          def repo_full_name
            @params.dig(:pull_request, :base, :repo, :full_name)
          end

          def pull_number
            @params.dig(:pull_request, :number)
          end

          def token
            ::Github::Apps::AccessTokens::Fetcher.new(
              client_id: Rails.application.config.github_app_client_id,
              private_key: Rails.application.config.github_app_private_key,
              installation_id: @params.dig(:installation, :id)
            ).perform
          end

          def octokit
            @octokit ||= Octokit::Client.new(access_token: token)
          end
      	end
      end
    end
  end
end