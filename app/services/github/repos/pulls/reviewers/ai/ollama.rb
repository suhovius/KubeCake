module Github
  module Repos
    module Pulls
      module Reviewers
        module AI
          class Ollama < Base
            private

            def prepare_comment_text
              <<~MARKDOWN.strip
                Test message is added here!
                ### Diff
                ```
                #{@octokit.pull_request_files(@repo_full_name, @pull_number)}
                ```
              MARKDOWN
            end
          end
        end
      end
    end
  end
end