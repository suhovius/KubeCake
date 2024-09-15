class CreateGithubRepositoryAICodeReviewPrompts < ActiveRecord::Migration[7.1]
  def change
    create_table :github_repository_ai_code_review_prompts do |t|
      t.references :repository, null: false, foreign_key: { to_table: :github_repositories }
      t.references :prompt, null: false, foreign_key:  { to_table: :ai_code_review_prompts }
      t.integer :survey_questions, :position, default: 0

      t.timestamps
    end

    add_index :github_repository_ai_code_review_prompts, %i[repository_id prompt_id], unique: true
  end
end
