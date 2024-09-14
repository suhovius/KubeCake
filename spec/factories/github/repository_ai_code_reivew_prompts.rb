FactoryBot.define do
  factory :github_repository_ai_code_reivew_prompt, class: 'Github::RepositoryAICodeReivewPrompt' do
    repository { nil }
    prompt { nil }
  end
end
