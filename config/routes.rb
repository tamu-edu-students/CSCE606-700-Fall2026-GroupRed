Rails.application.routes.draw do
  devise_for :users
  resource :companion, only: %i[ show edit update ]
  resources :companion_messages, only: :create do
    resources :reports, only: :create, controller: "companion_message_reports"
  end
  resource :profile, only: %i[ show new create edit update destroy ]
  resources :people, only: :show do
    resource :block, only: %i[ create destroy ]
    resources :reports, only: %i[ new create ]
  end
  resources :blocks, only: :index
  resources :reports, only: :index
  resources :swipes, only: %i[index create] do
    collection do
      post :undo
      post :change_decision
    end
  end
  resources :history, only: :index, controller: "swipes", action: "history"
  resources :matches, only: %i[ index show ] do
    resources :messages, only: :create
  end

  get "admin", to: "admin#index", as: :admin

  namespace :admin do
    resources :reports, only: [] do
      member do
        patch :ban
        patch :dismiss
      end
    end
    resources :users, only: [] do
      patch :pardon, on: :member
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  root "home#index"

  get "not-authorized", to: "errors#forbidden", as: :not_authorized
end
