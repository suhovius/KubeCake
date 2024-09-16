FactoryBot.define do
  factory :github_repository, class: 'Github::Repository' do
    sequence(:external_id) { |n| "fake-#{n}-#{FFaker::Lorem.word}" }
    node_id { ['FAKE', SecureRandom.hex(8)].join('_') }
    sequence(:name) { |n| (['fake'] + FFaker::Lorem.words(3) + [n]).join('-') }
    private { [true, false].sample }

    to_create do |instance|
      owner_login = (['fake'] + FFaker::Lorem.words(3)).join('-')
      instance.full_name = "#{owner_login}/#{instance.name}"
      instance.save
    end
  end
end