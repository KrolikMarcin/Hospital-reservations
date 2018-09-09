Rails.application.routes.draw do
  root 'reservations#index'
  get 'bills/not_paid', to: 'bills#not_paid'
  devise_for :users
  resources :bills, only: :index
  resources :reservations, shallow: true do
    get 'doctor_choice'
    patch 'doctor_choice_save'
    resources :bills, only: :show
  end
  resources :addresses, only: [:show, :new, :edit, :create, :index]
  namespace :admin do
    resources :reservations, only: [:index, :show] do
      get 'change_status'
      patch 'change_status_save'
    end
    resources :bills, only: [:index, :show, :new, :create] do
      patch 'pay_bill'
    end
  end
end
