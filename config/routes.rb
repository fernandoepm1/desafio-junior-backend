Rails.application.routes.draw do
  devise_for :users , controllers: { registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  resources :users, only: %i[edit update index] do
    member do
      get 'messages'
    end
  end

  resources :messages do
    collection do
      get 'sent'
    end
  end

  get   '/archived',         to: 'messages#archived'
  patch '/archive',          to: 'messages#archive',          defaults: { format: 'js' }
  patch '/archive_multiple', to: 'messages#archive_multiple', defaults: { format: 'js' }

  # API endpoints
  namespace :api do
    namespace :v1 do
      resource :profile, only: %i[show update], controller: 'profile'

      resources :messages, only: %i[index create show] do
        collection do
          get 'sent'
        end
      end
    end
  end
end
