class CreateAICodeReviewPrompts < ActiveRecord::Migration[7.1]
  def change
    create_table :ai_code_review_prompts do |t|
      t.string :title, null: false
      t.string :template, null: false

      t.timestamps
    end
  end
end
