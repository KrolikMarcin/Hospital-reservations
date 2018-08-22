Rails.application.routes.draw do
  root 'appointments#index'
  get 'bills/not_paid', to: 'bills#not_paid'
  devise_for :users
  devise_for :admins do
    resources :employees
  end
  resources :appointments, only: [:index]
  resources :patients, only: [:index, :show], shallow: true do
    resources :bills, only: [:index]
    resources :appointments, only: [:index]
    resources :reservations do
      resources :appointments, only: [:show] do
        get 'doctor_choice'
        patch 'doctor_choice_save'
        get 'change_status'
        resources :bills, only: [:new, :create, :show]
      end
    end
  end
end
