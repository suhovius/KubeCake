module Github
  class Account < ApplicationRecord
  	has_many :installations,
  					 class_name: 'Github::Installation',
  					 foreign_key: :account_id,
  					 dependent: :destroy
  end
end