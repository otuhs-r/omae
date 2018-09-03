Rails.application.routes.draw do
  root 'attendances#dashboard'
  devise_for :users
  get 'users/show', to: 'users#show'
  resources :users, except: :show do
    resources :attendances, except: :show
  end
  namespace :api do
    resources :users, only: [] do
      resources :attendances, only: [:create] do
        collection do
          get 'by_day_of_week'
        end
      end
    end
  end
end
