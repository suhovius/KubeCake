ActiveAdmin.register Organization do
  menu priority: 0

  filter :name
  filter :description
  filter :created_at
  filter :updated_at

  actions :all, except: :destroy

  permit_params :name, :description

  scope_to :current_admin_user,
           association_method: :assigned_organizations,
           unless: proc { current_admin_user.has_role?(:super_admin) }

  show do |organization|
    attributes_table do
      row :name
      row :description
      row :created_at
      row :updated_at
    end
  end

  index do
    column :name do |organization|
      link_to organization.name, admin_organization_path(organization)
    end

    column :description
    column :created_at
    column :updated_at
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :description
    end

    f.actions
  end

  sidebar 'Entities', only: [:show, :edit], if: -> { authorized?(:update, resource) } do
    ul do
      li link_to 'Organization Admins', admin_organization_organization_admins_path(resource)
    end
  end

  controller do
    def index
      unless current_admin_user.has_role?(:super_admin)
        if current_admin_user.assigned_organizations.count == 1
          redirect_to(
            admin_organization_path(current_admin_user.assigned_organizations.first)
          ) and return
        end
      end

      super
    end
  end
end
