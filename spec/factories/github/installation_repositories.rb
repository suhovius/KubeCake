FactoryBot.define do
  factory :github_installation_repository, class: 'Github::InstallationRepository' do
    association(:installation, factory: :github_installation)
    association(:repository, factory: :github_repository)
  end
end
