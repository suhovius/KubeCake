module Github
  module Repos
    module Pulls
      module Reviewers
        module AI
          class Ollama < Base
            private

            def prepare_comment_text
              <<~MARKDOWN.strip
                ### Base SHA
                #{@pull_request_data.dig(:base, :sha)}
                ### Head SHA
                #{@pull_request_data.dig(:head, :sha)}
              MARKDOWN
            end
          end
        end
      end
    end
  end
end