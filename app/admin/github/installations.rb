ActiveAdmin.register Github::Installation do
  menu label: 'Installations',
       parent: 'Github',
       priority: 3

  actions :index, :show

  filter :external_id, as: :string, label: 'External ID'
  filter :client_id, as: :string, label: 'Client ID'

  filter :account_id,
         as: :select,
         collection: -> { Github::Account.all }

  filter :repository_selection, as: :select,
                                collection: Github::Installation::REPOSITORY_SELECTION

  filter :external_app_id, label: 'External App ID'
  filter :created_at
  filter :updated_at

  show do |installation|
    attributes_table do
      row :id
      row('External ID') { installation.external_id }
      row('Client ID') { installation.client_id }
      row(:account) do
        link_to(
          installation.account.login,
          admin_github_account_path(installation.account_id)
        )
      end
      row(:repository_selection)
      row(:html_url) do
        link_to(installation.html_url, installation.html_url, target: :_blank)
      end
      row("External App ID") { |installation| installation.external_app_id }
      row(:app_slug)
      row(:events)
      row(:permissions) do
        content_tag(:pre) do
          JSON.pretty_generate(installation.permissions) if installation.permissions.present?
        end
      end
      row :created_at
      row :updated_at
    end

    panel 'Repositories' do
      table_for installation.repositories do
        column(:id)
        column('External ID') { |repository| repository.external_id }
        column('Node ID') { |repository| repository.node_id }
        column(:name)
        column(:full_name) do |repository|
          link_to(
            repository.full_name,
            ['https://github.com', repository.full_name].join('/'),
            target: :_blank
          )
        end
        column(:private)
        column :created_at
        column :updated_at
        column(:actions) do |repository|
          span link_to 'Show', admin_github_repository_path(repository)
        end
      end
    end
  end

  index do
    column :id
    column('External ID') { |installation| installation.external_id }
    column('Client ID') { |installation| installation.client_id }
    column(:account) do |installation|
      link_to(
        installation.account.login,
        admin_github_account_path(installation.account_id)
      )
    end
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
    actions
  end
end
