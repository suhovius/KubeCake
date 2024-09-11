FactoryBot.define do
  factory :github_repository, class: 'Github::Repository' do
    external_id { "MyString" }
    name { "MyString" }
    full_name { "MyString" }
    private { false }
  end
end
