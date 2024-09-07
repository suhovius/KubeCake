require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  authenticate :admin_user, lambda { |au| au.admin? } do
    mount Sidekiq::Web => '/sidekiq'

    # rSwag docs
    mount Rswag::Api::Engine => 'admin/api-docs'
    mount Rswag::Ui::Engine => 'admin/api-docs'
  end

  get '/', to: 'root#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
