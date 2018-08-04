Rails.application.routes.draw do
  root 'users#dashboard'
  devise_for :users
  get 'users/show', to: 'users#show'
  resources :users, except: :show do
    resources :attendances, except: :show
  end
end
