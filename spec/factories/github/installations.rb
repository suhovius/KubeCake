FactoryBot.define do
  factory :github_installation, class: 'Github::Installation' do
    external_id { "MyString" }
    account { nil }
    repository_selection { "MyString" }
    html_url { "MyString" }
    external_app_id { "MyString" }
    data { "" }
  end
end
