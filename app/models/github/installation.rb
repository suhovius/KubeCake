module Github
  class Installation < ApplicationRecord
    REPOSITORY_SELECTION = %w[all selected].freeze

    belongs_to :account, class_name: 'Github::Account'

    has_many :installation_repositories,
             class_name: 'Github::InstallationRepository',
             dependent: :destroy

    has_many :repositories,
             through: :installation_repositories,
             source: :repository

    store_accessor :data, :permissions, :events
  end
end