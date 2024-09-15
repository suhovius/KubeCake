# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

if Rails.env.development? || Rails.env.production?
  super_admin_email = ENV.fetch('SUPER_ADMIN_EMAIL', 'super.admin@kubecake.com')

  # Admin User for development purposes
  # in production admins must have secure passwords
  unless AdminUser.exists?(email: super_admin_email)
    admin_user = AdminUser.create!(
      email: super_admin_email,
      password: ENV.fetch('SUPER_ADMIN_PASSWORD'),
      password_confirmation: ENV.fetch('SUPER_ADMIN_PASSWORD')
    )

    admin_user.add_role(:super_admin)
  end

  organization = Organization.find_by(name: 'DevOps Code Review')

  unless organization
    organization = Organization.create!(
      name: 'DevOps Code Review', description: 'GitOps and Infrastructure Code Reviews'
    )
  end

  # Prompt Templates
  Dir["#{::Rails.root}/config/prompts/**/*.yml"].sort.each do |file_path|
    prompt_data = YAML.load(File.read(file_path))

    # Skip if already exists
    next if AI::CodeReview::Prompt.find_by(title: prompt_data['title'])

    AI::CodeReview::Prompt.create!(prompt_data)
  end
end
