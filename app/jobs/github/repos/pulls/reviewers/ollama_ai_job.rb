module Github
  module Repos
    module Pulls
      module Reviewers
        class OllamaAIJob < ApplicationJob
          queue_as :code_reviews

          def perform(**args)
            installation_id = args.fetch('installation_id')

            token = token_for(installation_id)

            ::Github::Repos::Pulls::Reviewers::OllamaAI.new(
              octokit: octokit_for(token),
              repo_full_name: args.fetch('repo_full_name'),
              pull_number: args.fetch('pull_number')
            ).perform
          end

          private

          def token_for(installation_id)
            ::Github::Apps::AccessTokens::Fetcher.new(
              client_id: Rails.application.config.github_app_client_id,
              private_key: Rails.application.config.github_app_private_key,
              installation_id: installation_id
            ).perform
          end

          def octokit_for(token)
            Octokit::Client.new(access_token: token)
          end
        end
      end
    end
  end
end
