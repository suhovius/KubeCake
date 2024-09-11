class CreateGithubAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :github_accounts do |t|
      t.string :external_id, null: false
      t.string :node_id, null: false
      t.string :login, null: false
      t.string :html_url
      t.string :avatar_url
      t.string :entity_type, null: false
      t.boolean :site_admin

      t.timestamps
    end

    add_index :github_accounts, :external_id, unique: true
  end
end
