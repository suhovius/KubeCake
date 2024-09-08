module Github
  module Repos
    module Pulls
      module Reviewers
        class Base
          def initialize(octokit:, owner:, repo:, pull_number:)
            @octokit = octokit
            @owner = owner
            @repo = repo
            @pull_number = pull_number
          end

          def perform
            pull_request_data
            comment_text = prepare_comment_text
            add_comment(comment_text)
          end

          private

          def prepare_comment_text
            raise NotImplementedError.new("#{self.class}##{__method__} is not implemented!")
          end

          def fetch_pull_request_data
            @octokit.pull_request([@owner, @repo].join('/'), @pull_number)
          end

          def pull_request_data
            @pull_request_data ||= fetch_pull_request_data
          end

          def add_comment(comment_text)
            @octokit.add_comment([@owner, @repo].join('/'), @pull_number, comment_text)
          end
        end
      end
    end
  end
end