# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_09_11_012641) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_admin_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_admin_roles_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "admin_users_admin_roles", id: false, force: :cascade do |t|
    t.bigint "admin_user_id"
    t.bigint "admin_role_id"
    t.index ["admin_role_id"], name: "index_admin_users_admin_roles_on_admin_role_id"
    t.index ["admin_user_id", "admin_role_id"], name: "idx_on_admin_user_id_admin_role_id_c0859d813f"
    t.index ["admin_user_id"], name: "index_admin_users_admin_roles_on_admin_user_id"
  end

  create_table "github_accounts", force: :cascade do |t|
    t.string "external_id", null: false
    t.string "node_id", null: false
    t.string "login", null: false
    t.string "html_url"
    t.string "avatar_url"
    t.string "entity_type", null: false
    t.boolean "site_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_github_accounts_on_external_id", unique: true
  end

  create_table "github_installation_repositories", force: :cascade do |t|
    t.bigint "installation_id", null: false
    t.bigint "repository_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["installation_id", "repository_id"], name: "idx_on_installation_id_repository_id_780bf1ede2", unique: true
    t.index ["installation_id"], name: "index_github_installation_repositories_on_installation_id"
    t.index ["repository_id"], name: "index_github_installation_repositories_on_repository_id"
  end

  create_table "github_installations", force: :cascade do |t|
    t.string "external_id", null: false
    t.string "client_id", null: false
    t.bigint "account_id", null: false
    t.string "repository_selection"
    t.string "html_url"
    t.string "external_app_id", null: false
    t.string "app_slug", null: false
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_github_installations_on_account_id"
    t.index ["external_id"], name: "index_github_installations_on_external_id", unique: true
  end

  create_table "github_repositories", force: :cascade do |t|
    t.string "external_id", null: false
    t.string "node_id", null: false
    t.string "name", null: false
    t.string "full_name"
    t.boolean "private"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_github_repositories_on_external_id", unique: true
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "github_installation_repositories", "github_installations", column: "installation_id"
  add_foreign_key "github_installation_repositories", "github_repositories", column: "repository_id"
  add_foreign_key "github_installations", "github_accounts", column: "account_id"
end
