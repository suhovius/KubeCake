module Github
  module Repos
    module Pulls
      module Reviewers
        class OllamaAI < Base
          private

          def prepare_comment_text
            generated_data.first.dig('response')
          end

          def generated_data
            ollama_client.generate(
              {
                model: Rails.application.config.ollama_model,
                prompt: prompt_for(diff_text),
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

          # TODO: Make this prompt configurable per each repo at admin
          # Add this line too
          # 'To help you understand the changes, here are the commit messages: #{messages} (do not use them as the sole criteria)'
          def prompt_for(diff_text)
            <<~PROMPT.strip.freeze
              ====
              The changed files in this diff: #{diff_text}. Concentrate your analysis on these files only.

              ====
              Given you are preparing a pull request for your colleagues, summarize the git diff and out in markdown format:

              Add a Summary for summarize the change in at most one paragraph.
              Add a Additions section for laying down the code additions in terms of meaning. Be more detailed here.
              Add a Updates section tohighlight the code updates in terms of meaning. Be more detailed here.
              Add a Deletes section to tell removed code, if any.
              Add a Review order section. In this section suggest a good order to check files so a reviewer can easily follow the changes. Here indicate the files and the source.

              Important: Never output again the whole or part of the diff. You don't need to reproduce each change, \
              just highlight the change and how the code looks like after the change. Feel free to rise a potential business impact with the change.
              Also remember that diff files use a plus sign to indicate additions and negative sign to indicate removals. It is not useful to know a new line was added, changed or removed. We are here for the meaning of things. Also do not sensitive data if you see them.

              Tell me how this summarized changes (without making suppositions) can affect my whole codebase. Please mention the source of places that can be impacted by the changes above and the expected outcome of the changes. Do not make comments about the existing codebase, but rather on the changes applied to it. Do not make generic engineering suggestions of improvements. If impact is not clear, don't bring generic comments.
            PROMPT
          end
        end
      end
    end
  end
end