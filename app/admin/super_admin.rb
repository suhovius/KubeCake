ActiveAdmin.register AdminUser, as: 'SuperAdmin' do
  menu label: 'Super admins',
    parent: 'Settings',
    priority: 2,
    if: -> { current_admin_user.has_cached_role?(:super_admin) }

  config.batch_actions = false
  config.filters = false

  actions :all, except: :destroy
  permit_params :email, :password

  action_item :withdraw_access, only: [:edit, :show] do
    link_to(
      'Withdraw access',
      withdraw_access_admin_super_admin_path(resource),
      method: :put
    )
  end

  member_action :withdraw_access, method: :put do
    if current_admin_user == resource
      redirect_back fallback_location: admin_super_admin_path,
                    error: 'This action is not allowed'
    else
      resource.revoke(:super_admin)
      resource.destroy unless resource.admin?
      redirect_to admin_super_admins_path,
                  notice: 'Access has been withdrawn successfully'
    end
  end

  form do |f|
    f.inputs 'Admin Details' do
      f.input :email
      f.input :password
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :email
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :created_at
      row :updated_at
    end
  end

  index do
    column :email
    column :created_at
    actions
  end

  controller do
    after_action :assign_super_access, only: [:create]

    def scoped_collection
      end_of_association_chain.with_role(:super_admin).preload(:roles)
    end

    private

    def authorized?(_action, _subject = nil)
      current_admin_user.has_role?(:super_admin)
    end

    def assign_super_access
      resource&.grant(:super_admin)
    end
  end
end
