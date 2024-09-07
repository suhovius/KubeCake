FactoryBot.define do
  factory :organization, class: Organization do
    sequence(:name) { |n| "#{n}-#{FFaker::Lorem.word}" }
    description { FFaker::Lorem.sentence }
  end
end
