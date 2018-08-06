Rails.application.routes.draw do
  root 'reservations#index'
  devise_for :users
  resources :employees
  resources :reservations, :appointments, only: [:index]
  resources :patients, only: [:index, :show] do
    resources :reservations, shallow: true do
      resources :appointments, only: [:show, :index] do
        get 'doctor_choice'
        patch 'doctor_choice_save'
        get 'change_status'
        get 'create'
        resources :bills
      end
    end
  end
end
