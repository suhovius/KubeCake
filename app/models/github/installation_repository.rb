module Github
  class InstallationRepository < ApplicationRecord
    belongs_to :installation, class_name: 'Github::Installation'
    belongs_to :repository, class_name: 'Github::Repository'
  end
end