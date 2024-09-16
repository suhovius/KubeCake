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
  Rake::Task['ai:code_review:prompts:create'].invoke
end

if Rails.env.development?
  prompts = ::AI::CodeReview::Prompt.all

  if ENV.fetch('GENERATE_DUMMY_GITHUB_DATA') == 'yes'
    FactoryBot.create_list(:github_account, 50).each do |account|
      time = ::FFaker::Time.between(Time.zone.now - 30.days, Time.zone.now)
      installation = FactoryBot.create(:github_installation, account:, created_at: time, updated_at: time)

      FactoryBot.create_list(:github_repository, 10 + rand(50)).each do |repository|
        installation.repositories << repository
        selected_prompts = []
        selected_prompts += prompts.practical.sample(prompts.practical.count)
        selected_prompts += prompts.experimental.sample(3)
        selected_prompts += prompts.fun.sample(2)
        repository.ai_code_review_prompts = selected_prompts
      end
    end
  end
end