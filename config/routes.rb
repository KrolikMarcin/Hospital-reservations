Rails.application.routes.draw do
  root 'reservations#index'
  get 'bills/not_paid', to: 'bills#not_paid'
  devise_for :users
  resources :bills, only: :index do
    patch 'pay_bill'
  end
  resources :prescriptions, only: :index
  resources :reservations, shallow: true do
    get 'doctor_choice'
    patch 'doctor_choice_save'
    get 'change_status'
    patch 'change_status_save'
    resources :bills, only: :show
  end
  resources :addresses
  namespace :admin do
    resources :reservations, only: [:index, :show]
    resources :bills, only: [:index, :show, :new, :create]
  end
end
