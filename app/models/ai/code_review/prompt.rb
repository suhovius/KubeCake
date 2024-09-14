module AI
  module CodeReview
	class Prompt < ApplicationRecord
	  validates :title, :template, presence: true
	end
  end
end
