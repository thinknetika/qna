Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :questions do
    resources :answers, except: %i[index show], shallow: true do
      post "vote", on: :member
    end

    post "vote", on: :member
  end

  resources :best_answers, only: %i[create], path: :best_answer, as: :best_answers

  resources :attachments, only: :destroy

  root to: "questions#index"
end
