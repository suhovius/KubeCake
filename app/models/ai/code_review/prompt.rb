module AI
  module CodeReview
		class Prompt < ApplicationRecord
		  validates :title, :key, :template, presence: true
		  validates :key, uniqueness: true

		  CATEGORIES = %w[practical experimental fun].freeze
		  validates :category, presence: true, inclusion: { in: CATEGORIES }

		  scope :practical, -> { where(category: 'practical') }
		  scope :experimental, -> { where(category: 'experimental') }
		  scope :fun, -> { where(category: 'fun') }
		end
  end
end
