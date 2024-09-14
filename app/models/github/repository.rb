module Github
  class Repository < ApplicationRecord
  	has_many :installation_repositories,
  	         class_name: 'Github::InstallationRepository',
  	         dependent: :destroy

  	has_many :installations,
  	         through: :installation_repositories,
  	         source: :installation

    has_many :repository_ai_code_review_prompts,
             class_name: 'Github::RepositoryAICodeReivewPrompt',
             dependent: :destroy

    has_many :ai_code_review_prompts,
             through: :repository_ai_code_review_prompts,
             source: :prompt
  end
end