module Github
  class RepositoryAICodeReviewPrompt < ApplicationRecord
    belongs_to :repository, class_name: 'Github::Repository'
    belongs_to :prompt, class_name: 'AI::CodeReview::Prompt'

    acts_as_list scope: %i[repository_id]
  end
end
