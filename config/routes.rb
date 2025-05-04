Rails.application.routes.draw do
  devise_for :users

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

  root to: "questions#index"

  mount ActionCable.server => "/cable"
end
