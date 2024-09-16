module AI
  module CodeReview
		class Prompt < ApplicationRecord
		  validates :title, :key, :template, presence: true
		  validates :title, :key, uniqueness: true

		  CATEGORIES = %w[practical experimental fun].freeze
		  validates :category, presence: true, inclusion: { in: CATEGORIES }

		  scope :practical, -> { where(category: 'practical') }
		  scope :experimental, -> { where(category: 'experimental') }
		  scope :fun, -> { where(category: 'fun') }

		  has_many :repository_ai_code_review_prompts,
               class_name: 'Github::RepositoryAICodeReviewPrompt',
               dependent: :destroy

	    has_many :repositories,
	             through: :repository_ai_code_review_prompts,
	             source: :repository
		end
  end
end
