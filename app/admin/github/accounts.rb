ActiveAdmin.register Github::Account do
  menu label: 'Accounts',
       parent: 'Github',
       priority: 2

  actions :index, :show

  filter :external_id, as: :string, label: 'External ID'
  filter :node_id, as: :string, label: 'Node ID'
  filter :login, as: :string

  filter :entity_type, as: :select,
                       label: 'Entity Type',
                       collection: Github::Account::ENTITY_TYPES

  filter :site_admin, as: :boolean
  filter :created_at
  filter :updated_at

  show do |account|
    attributes_table do
      row :id
      row('External ID') { account.external_id }
      row('Node ID') { account.node_id }
      row(:login)
      row(:html_url) { link_to(account.html_url, account.html_url, target: :_blank) }
      row(:avatar) { image_tag(account.avatar_url) }
      row(:entity_type)
      row(:site_admin)
      row :created_at
      row :updated_at
    end

    panel 'Installations' do
      table_for account.installations do
        column :id
        column('External ID') { |installation| installation.external_id }
        column('Client ID') { |installation| installation.client_id }
        column(:repository_selection)
        column(:html_url) do |installation|
          link_to(installation.html_url, installation.html_url, target: :_blank)
        end
        column("External App ID") { |installation| installation.external_app_id }
        column(:app_slug)
        column(:events)
        column(:permissions) do |installation|
          content_tag(:pre) do
            JSON.pretty_generate(installation.permissions) if installation.permissions.present?
          end
        end
        column :created_at
        column :updated_at
        column(:actions) do |installation|
          span link_to 'Show', admin_github_installation_path(installation)
        end
      end
    end
  end

  index do
    column :id
    column('External ID') { |account| account.external_id }
    column('Node ID') { |account| account.node_id }
    column(:login)
    column(:html_url) { |account| link_to(account.html_url, account.html_url, target: :_blank) }
    column(:avatar) { |account| image_tag(account.avatar_url, class: 'small-image') }
    column(:entity_type)
    column(:site_admin)
    column :created_at
    column :updated_at
    actions
  end
end
