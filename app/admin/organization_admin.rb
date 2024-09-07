ActiveAdmin.register AdminUser, as: 'OrganizationAdmin' do
  config.batch_actions = false
  config.filters = false

  belongs_to :organization
  navigation_menu :default
  menu false

  before_action only: %i[new create] do
    authorize! :create_organization_admin, AdminUser
  end

  actions :all, except: :destroy
  permit_params :email, :password

  action_item :withdraw_access, only: [:edit, :show] do
    link_to(
      'Withdraw',
      withdraw_access_admin_organization_organization_admin_path(
        organization,
        resource
      ),
      method: :put
    )
  end

  action_item(
    :assign_admin,
    only: :index,
    if: proc { current_admin_user.has_role?(:super_admin) }
  ) do
    link_to 'Assign Admin', admin_organization_assign_admins_path(organization)
  end

  member_action :withdraw_access, method: :put do
    if current_admin_user == resource
      redirect_back fallback_location: admin_super_admin_path,
                    alert: 'This action is not allowed'
    else
      resource.revoke(:organization_admin, parent)
      resource.destroy unless resource.admin?
      redirect_to admin_organization_organization_admins_path(parent),
                  notice: 'Access has been withdrawn successfully'
    end
  end

  form do |f|
    f.inputs 'Admin User' do
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
    after_action :grant_organization_access, only: [:create]

    def scoped_collection
      parent.assigned_admins
    end

    private

    def grant_organization_access
      resource&.grant(:organization_admin, parent)
    end
  end
end
