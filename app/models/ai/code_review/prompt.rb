module AI
  module CodeReview
		class Prompt < ApplicationRecord
		  validates :title, :template, presence: true
		  validates :title, uniqueness: true

		  CATEGORIES = %w[practical fun].freeze
		  validates :category, presence: true, inclusion: { in: CATEGORIES }

		  scope :summarizer, -> { where(title: 'Summarizer') }
		  scope :practical, -> { where(category: 'practical') }
		  scope :fun, -> { where(category: 'fun') }
		end
  end
end
