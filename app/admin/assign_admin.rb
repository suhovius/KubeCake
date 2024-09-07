ActiveAdmin.register AdminUser, as: 'AssignAdmin' do
  config.batch_actions = false
  config.filters = false

  belongs_to :organization
  navigation_menu :default
  menu false

  actions :index

  before_action do
    authorize! :assign_organization_admin, parent
  end

  member_action :assign, method: :put do
    resource&.grant :organization_admin, parent
    redirect_to admin_organization_organization_admins_path(parent)
  end

  index do
    column :email
    column :created_at
    actions do |resource|
      link_to(
        'Assign',
        assign_admin_organization_assign_admin_path(organization, resource),
        method: :put
      )
    end
  end

  controller do
    def scoped_collection
      AdminUser.resource_type(parent.class).without_role(:organization_admin, parent)
    end
  end
end
