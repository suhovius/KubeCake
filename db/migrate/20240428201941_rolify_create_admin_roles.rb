class RolifyCreateAdminRoles < ActiveRecord::Migration[7.1]
  def change
    create_table(:admin_roles) do |t|
      t.string :name
      t.references :resource, :polymorphic => true

      t.timestamps
    end

    create_table(:admin_users_admin_roles, :id => false) do |t|
      t.references :admin_user
      t.references :admin_role
    end
    
    add_index(:admin_roles, [ :name, :resource_type, :resource_id ])
    add_index(:admin_users_admin_roles, [ :admin_user_id, :admin_role_id ])
  end
end
