class CreateGithubInstallations < ActiveRecord::Migration[7.1]
  def change
    create_table :github_installations do |t|
      t.string :external_id, null: false
      t.string :client_id, null: false
      t.references :account, null: false, foreign_key: { to_table: :github_accounts }
      t.string :repository_selection
      t.string :html_url
      t.string :external_app_id, null: false
      t.string :app_slug, null: false
      t.jsonb :data, default: {}

      t.timestamps
    end

    add_index :github_installations, :external_id, unique: true
  end
end
