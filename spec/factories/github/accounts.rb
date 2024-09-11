FactoryBot.define do
  factory :github_account, class: 'Github::Account' do
    external_id { "MyString" }
    login { "MyString" }
    html_url { "MyString" }
    avatar_url { "MyString" }
    entity_type { "MyString" }
    site_admin { false }
  end
end
