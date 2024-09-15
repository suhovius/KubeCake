class CreateAICodeReviewPrompts < ActiveRecord::Migration[7.1]
  def change
    create_table :ai_code_review_prompts do |t|
      t.string :title, null: false
      t.string :category, null: false
      t.string :template, null: false
      t.integer :reviews_count, null: false, default: 0

      t.timestamps
    end

    add_index :ai_code_review_prompts, :title, unique: true
  end
end
