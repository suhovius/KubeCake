module Github
  module Repos
    module Pulls
      module Reviewers
        class OllamaAI < Base
          DIFF_VARIABLE_NAME = '<diff_text>'.freeze
          COMMIT_MESSAGES_VARIABLE_NAME = '<commit_messages>'.freeze

          def initialize(octokit:, repo_full_name:, pull_number:, prompt:)
            super(octokit:, repo_full_name:, pull_number:)
            @prompt = prompt
          end

          private

          def prepare_comment_text
            [
              ['Reviewer:', @prompt.title].join(' '),
              "\n",
              generated_data.first.dig('response')
            ].join("\n")
          end

          def generated_data
            ollama_client.generate(
              {
                model: Rails.application.config.ollama_model,
                prompt: prepare_prompt,
                stream: false
              }
            )
          end

          def ollama_client
            @ollama_client ||= ::Ollama.new(
              credentials: { address: Rails.application.config.ollama_server_address }
            )
          end

          def diff_text
            diff_files = @octokit.pull_request_files(@repo_full_name, @pull_number)

            text = ""
            diff_files.each do |item|
              text += "#{item[:filename]}\n#{item[:patch]}\n"
            end

            text
          end

          def commit_messages
            commits = @octokit.pull_request_commits(@repo_full_name, @pull_number)

            text = ""
            commits.each do |item|
              text += "#{item.commit.message}\n"
            end
            text
          end

          def prepare_prompt
            @prompt.template.tap do |template|
              template.gsub!(DIFF_VARIABLE_NAME, diff_text)
              template.gsub!(COMMIT_MESSAGES_VARIABLE_NAME, commit_messages)
            end
          end
        end
      end
    end
  end
end