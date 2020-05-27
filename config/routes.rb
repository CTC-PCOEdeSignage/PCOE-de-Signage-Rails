require "sidekiq/web"
Rails.application.routes.draw do
  resources :screens, only: [:index, :show]

  resources :room do
    get :schedule, on: :member
  end

  authenticate :user do
    mount Sidekiq::Web => "/sidekiq"
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: "screens#index"
end
