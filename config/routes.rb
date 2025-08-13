require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper

  mount Sidekiq::Web => "/sidekiq"

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  get '/search', to: 'search#index', as: 'search'

  resources :questions do
    resources :answers, except: %i[index show], shallow: true do
      post "vote", on: :member

      resources "comments", except: %i[index], shallow: true
    end

    post "vote", on: :member

    resources "comments", only: %i[new create update destroy], shallow: true

    resource :subscription, only: [:create, :destroy], controller: 'question_subscriptions'
  end

  resources :best_answers, only: %i[create], path: :best_answer, as: :best_answers

  resources :attachments, only: :destroy

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, except: %i[edit], shallow: true do
        end
      end
    end
  end

  root to: "questions#index"

  mount ActionCable.server => "/cable"
end
