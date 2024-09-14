ActiveAdmin.register Github::Repository do
  menu label: 'Repositories',
       parent: 'Github',
       priority: 1

  actions :index, :show

  filter :external_id, as: :string, label: 'External ID'
  filter :node_id, as: :string, label: 'Node ID'
  filter :name, as: :string
  filter :full_name, as: :string
  filter :private, as: :boolean
  filter :created_at
  filter :updated_at

  show do |repository|
    attributes_table do
      row :id
      row('External ID') { repository.external_id }
      row('Node ID') { repository.node_id }
      row(:name)
      row(:full_name) do
        link_to(
          repository.full_name,
          ['https://github.com', repository.full_name].join('/'),
          target: :_blank
        )
      end
      row(:private)
      row :created_at
      row :updated_at
    end
  end

  index do
    column :id
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
    actions
  end
end
