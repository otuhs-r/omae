Rails.application.routes.draw do
  root 'users#index'
  devise_for :users

  get 'users/show', to: 'users#show'
end