FactoryBot.define do
  factory :github_account, class: 'Github::Account' do
    sequence(:external_id) { |n| "fake-#{n}-#{FFaker::Lorem.word}" }
    sequence(:login) { |n| "fake-#{n}-#{FFaker::Lorem.word}-#{FFaker::Lorem.word}" }
    entity_type { %w[User Organization].sample }
    site_admin { [true, false].sample }

    to_create do |instance|
      node_id_value = FFaker.numerify("fake:##:#{instance.entity_type}#{instance.external_id}")
      instance.node_id = Base64.strict_encode64(node_id_value)
      instance.html_url = "https://github.com/#{instance.login}"
      instance.avatar_url = "https://avatars.githubusercontent.com/u/#{instance.external_id}?v=4"
      instance.save
    end
  end
end

