FactoryBot.define do
  factory :github_repository_ai_code_review_prompt, class: 'Github::CodeReview' do
    repository { nil }
    prompt { nil }
  end
end
