module Github
  module Repos
    module Pulls
      module Reviewers
        class OllamaAI < Base
          VARIABLE_NAMES = {
            '<pull_request_title>'       => pull_request_title,
            '<pull_request_description>' => pull_request_description,
            '<commit_messages>'          => commit_messages,
            '<diff_text>'                => diff_text
          }.freeze

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

          def pull_request_title
            @pull_request_data[:title]
          end

          def pull_request_description
            @pull_request_data[:body]
          end

          def commit_messages
            commits = @octokit.pull_request_commits(@repo_full_name, @pull_number)

            text = ""
            commits.each do |item|
              text += "#{item.commit.message}\n"
            end
            text
          end

          def diff_text
            diff_files = @octokit.pull_request_files(@repo_full_name, @pull_number)

            text = ""
            diff_files.each do |item|
              text += "#{item[:filename]}\n#{item[:patch]}\n"
            end

            text
          end

          def prepare_prompt
            @prompt.template.tap do |template|
              VARIABLE_NAMES.each do |variable_name, value_method_name|
              template.gsub!(variable_name, value_method_name)
            end
          end
        end
      end
    end
  end
end