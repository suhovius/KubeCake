ActiveAdmin.register Github::Account do
  menu label: 'Accounts',
       parent: 'Github',
       priority: 2

  actions :index, :show

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
