Rails.application.routes.draw do
  resources :reviews
  resources :books do
    resources :reviews
  end
  root 'books#index'
  devise_for :users

  resources :users, only: [:show] do
    resources :reviews, only: [:index, :edit, :update, :destroy] # You can add other actions as needed
  end
end
