Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, except: %i[index show], shallow: true do
    end
  end

  resources :best_answers, only: %i[create], path: :best_answer, as: :best_answers

  resources :attachments, only: :destroy

  root to: "questions#index"
end
