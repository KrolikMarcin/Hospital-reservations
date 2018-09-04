Rails.application.routes.draw do
  root 'reservations#index'
  get 'bills/not_paid', to: 'bills#not_paid'
  devise_for :users
  resources :reservations, shallow: true do
    get 'doctor_choice'
    patch 'doctor_choice_save'
    get 'change_status'
    patch 'change_status_save'
    resources :bills, only: [:new, :create]
  end
  resources :bills, only: [:index, :show]
  resources :addresses, only: [:show, :new, :create, :index]
  namespace :admin do
    resources :reservations, only: [:index, :show] do
      
      get 'change_status'
      patch 'change_status_save'
    end
  end
end
