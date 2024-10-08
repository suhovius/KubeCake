ActiveAdmin.register AI::CodeReview::Prompt do
  menu label: 'Prompts',
       parent: 'AI Code Review',
       priority: 1

  permit_params :title, :key, :category, :template

  filter :title
  filter :key
  filter :template
  filter :category, as: :select, collection: AI::CodeReview::Prompt::CATEGORIES
  filter :reviews_count
  filter :created_at
  filter :updated_at

  show do |prompt|
    attributes_table do
      row :id
      row(:title) { emojify_unicode(prompt.title) }
      row :key
      row :category
      row(:template) do
        content_tag(:pre, class: 'prompt_template') do
          prompt.template
        end
      end
      row :reviews_count
      row :created_at
      row :updated_at
    end
  end

  index do
    column :id
    column(:title) { |prompt| emojify_unicode(prompt.title) }
    column :key
    column :category
    column(:template) { |prompt| prompt.template.truncate(100) }
    column :reviews_count
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs 'Prompt' do
      f.input :title, required: true
      f.input :key, required: true

      f.input :category,
              required: true,
              as: :select,
              collection: AI::CodeReview::Prompt::CATEGORIES,
              include_blank: false

      f.input(
        :template,
        as: :text,
        required: true,
        input_html: {
          rows: 35,
          placeholder: I18n.t('active_admin.ai.code_review.prompt.template.placeholder')
        },
        hint: "Can contain such variables: #{::Github::Repos::Pulls::Reviewers::OllamaAI::VARIABLE_NAMES.keys.join(', ')}",
      )
    end
    f.actions
  end
end