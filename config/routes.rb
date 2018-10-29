Rails.application.routes.draw do
  root 'pages#home'
  devise_for :users
  resources :bills, only: :index do
    patch 'pay_bill'
  end
  resources :prescriptions, only: [:index, :show]
  resources :reservations, shallow: true do
    get 'doctor_choice'
    patch 'doctor_choice_save'
    get 'change_status'
    patch 'change_status_save'
    resources :bills, only: :show
  end
  resources :addresses
  namespace :admin, shallow: true do
    resources :users, only: [:index, :show, :destroy] do
      get 'change_role'
    end
    resources :reservations, only: :index do
      resources :bills, only: [:new, :create]
    end
    resources :bills, only: [:index, :destroy]
  end
end
