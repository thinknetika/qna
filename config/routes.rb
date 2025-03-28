Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    member do
      delete 'file/:file_id', to: 'questions#destroy_file', as: :delete_file
    end

    resources :answers, except: %i[index show], shallow: true
  end

  resources :best_answers, only: [:create], path: :best_answer, as: :best_answers

  root to: "questions#index"
end
