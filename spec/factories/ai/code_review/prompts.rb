FactoryBot.define do
  factory :ai_code_review_prompt, class: 'AI::CodeReview::Prompt' do
    title { "MyString" }
    template { "MyString" }
  end
end
