class CreateGithubRepositories < ActiveRecord::Migration[7.1]
  def change
    create_table :github_repositories do |t|
      t.string :external_id, null: false
      t.string :node_id, null: false
      t.string :name, null: false
      t.string :full_name
      t.boolean :private

      t.timestamps
    end

    add_index :github_repositories, :external_id, unique: true
  end
end
