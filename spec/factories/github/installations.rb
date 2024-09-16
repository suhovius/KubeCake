FactoryBot.define do
  factory :github_installation, class: 'Github::Installation' do
    sequence(:external_id) { |n| "fake-#{n}-#{FFaker::Lorem.word}" }
    client_id { SecureRandom.alphanumeric(20) }
    association(:account, factory: :github_account)
    repository_selection { %w[all selected].sample }
    sequence(:external_app_id) { |n| "fake-#{n}" }
    sequence(:app_slug) { |n| (['fake', n] + FFaker::Lorem.words(3)).join('-') }
    data do
      {
        'events' => ['pull_request'],
        'permissions' => {
          'contents' => 'read',
          'metadata' => 'read',
          'pull_requests' => 'write'
        }
      }
    end

    to_create do |instance|
      instance.html_url = "https://github.com/settings/installations/#{instance.external_id}"
      instance.save
    end
  end
end