Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, except: %i[index show], shallow: true
  end

  resources :best_answers, only: [ :create ], path: :best_answer, as: :best_answers

  root to: "questions#index"
end
