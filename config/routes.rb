# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root to: redirect('/dashboard')
  get '/dashboard', to: 'dashboard#index'
  get '/search', to: 'search#index'
  get '/health', to: 'health#index'

  get '/onboarding', to: 'onboarding#index'
  post '/onboarding', to: 'onboarding#create'
  get '/onboarding/success', to: 'onboarding#success'
  post '/onboarding/invite', to: 'onboarding#create_invite_url'
  get '/onboarding/telegram', to: 'onboarding#telegram'
  patch '/onboarding/telegram-update-info', to: 'onboarding#telegram_update_info'
  get '/onboarding/telegram-explained', to: 'onboarding#telegram_explained'

  get '/settings', to: 'settings#index'
  post '/settings', to: 'settings#update'

  telegram_webhook Telegram::WebhookController

  resources :requests, only: %i[index show new create] do
    member do
      get 'notifications', format: /json/
    end
  end

  resources :contributors, except: :edit do
    resources :requests, only: %i[show], to: 'requests#show_contributor_messages'

    member do
      post 'message'
    end

    collection do
      get 'count'
    end
  end

  resources :messages do
    member do
      post 'highlight', format: /json/
    end
  end
end
