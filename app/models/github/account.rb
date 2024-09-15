module Github
  class Account < ApplicationRecord
    ENTITY_TYPES = %w[User Organization].freeze

  	has_many :installations,
  					 class_name: 'Github::Installation',
  					 foreign_key: :account_id,
  					 dependent: :destroy
  end
end