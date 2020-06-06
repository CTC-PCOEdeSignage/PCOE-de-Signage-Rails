require "sidekiq/web"
Rails.application.routes.draw do
  resources :screens, only: [:index, :show]

  resources :rooms, only: [:index] do
    resources :event_requests, only: [:new, :create, :show] do
      resource :confirmation, only: [:show] do
        get :verify
      end
    end
  end

  authenticate :admin_user do
    mount Sidekiq::Web => "/sidekiq"
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: "screens#index"
end
