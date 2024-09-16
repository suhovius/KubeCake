ActiveAdmin.register Github::Repository do
  menu label: 'Repositories',
       parent: 'Github',
       priority: 1

  actions :index, :show, :edit, :update

  permit_params ai_code_review_prompt_ids: []

  filter :external_id, as: :string, label: 'External ID'
  filter :node_id, as: :string, label: 'Node ID'
  filter :name, as: :string
  filter :full_name, as: :string
  filter :private, as: :boolean
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs 'Github Repository' do
      f.input :ai_code_review_prompt_ids,
              label: 'AI Code Review Prompts',
              required: true,
              as: :select,
              multiple: true,
              collection: AI::CodeReview::Prompt.all.map { |prompt| [emojify_unicode(prompt.title), prompt.id] },
              include_blank: false
    end
    f.actions
  end

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

    panel 'Prompts' do
      reorderable_table_for repository.repository_ai_code_review_prompts.preload(:prompt) do
        column(:id) { |item| item.prompt.id }
        column(:title) { |item| emojify_unicode(item.prompt.title) }
        column(:key) { |item| item.prompt.key }
        column(:category) { |item| item.prompt.category }
        column(:template) { |item| item.prompt.template.truncate(100) }
        column :created_at
        column :updated_at
        column(:actions) do |item|
          span link_to 'Show', admin_ai_code_review_prompt_path(item.prompt)
        end
      end
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
