FactoryBot.define do
  factory :github_installation_repository, class: 'Github::InstallationRepository' do
    installation { nil }
    repository { nil }
  end
end
