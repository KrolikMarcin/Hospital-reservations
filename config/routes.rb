Rails.application.routes.draw do
  root 'reservations#index'
  devise_for :users
  resources :employees
  resources :reservations, :appointments, only: [:index]
  resources :patients, only: [:index, :show] do
    resources :reservations do
      resources :appointments do
        get 'doctor_choice'
        patch 'doctor_choice_save'
      end
    end
  end
end
