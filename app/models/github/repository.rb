module Github
  class Repository < ApplicationRecord
  	has_many :installation_repositories,
  	         class_name: 'Github::InstallationRepository',
  	         dependent: :destroy

  	has_many :installations,
  	         through: :installation_repositories,
  	         source: :installation
  end
end