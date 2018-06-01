Rails.application.routes.draw do
  resources :screens, only: [:index, :show]

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: "screens#index"
end
