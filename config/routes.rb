Rails.application.routes.draw do
  get 'others/help'
  get 'others/disclaimer'
  get 'others/welcome'
  root 'others#welcome'
  devise_for :users, controllers: { registrations: 'registrations' }
  get 'users/show', to: 'users#show'
  post 'attendances/clock_in_just_now', to: 'attendances#clock_in_just_now'
  post 'attendances/clock_out_just_now', to: 'attendances#clock_out_just_now'
  resources :users, only: [] do
    resources :attendances, except: :show
    get 'attendances/weekly', to: 'attendances#weekly'
    get 'attendances/monthly', to: 'attendances#monthly'
    get 'attendances/summary', to: 'attendances#summary'
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
