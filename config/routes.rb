Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :questions do
    resources :answers, except: %i[index show], shallow: true do
      post "vote", on: :member

      resources "comments", only: %i[new create edit update destroy], shallow: true
    end

    post "vote", on: :member

    resources "comments", only: %i[new create update destroy], shallow: true
  end

  resources :best_answers, only: %i[create], path: :best_answer, as: :best_answers

  resources :attachments, only: :destroy

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: [:index]
    end
  end

  root to: "questions#index"

  mount ActionCable.server => "/cable"
end
