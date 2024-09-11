class CreateGithubInstallationRepositories < ActiveRecord::Migration[7.1]
  def change
    create_table :github_installation_repositories do |t|
      t.references :installation, null: false, foreign_key: { to_table: :github_installations }
      t.references :repository, null: false, foreign_key: { to_table: :github_repositories }

      t.timestamps
    end

    add_index :github_installation_repositories, %i[installation_id repository_id], unique: true
  end
end
