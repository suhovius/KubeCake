ActiveAdmin.register AI::CodeReview::Prompt do
  menu label: 'Prompts',
       parent: 'AI Code Review',
       priority: 1

  permit_params :title, :category, :template

  filter :title
  filter :template
  filter :category, as: :select, collection: AI::CodeReview::Prompt::CATEGORIES

  filter :created_at
  filter :updated_at

  show do |prompt|
    attributes_table do
      row :id
      row :title
      row :category
      row(:template) do
        content_tag(:pre, class: 'prompt_template') do
          prompt.template
        end
      end
      row :created_at
      row :updated_at
    end
  end

  index do
    column :id
    column :title
    column :category
    column(:template) { |prompt| prompt.template.truncate(100) }
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs 'Prompt' do
      f.input :title, required: true

      f.input :category,
              required: true,
              as: :select,
              collection: AI::CodeReview::Prompt::CATEGORIES,
              include_blank: false

      f.input(
        :template,
        as: :text,
        required: true,
        input_html: { rows: 35 }
      )
    end
    f.actions
  end
end