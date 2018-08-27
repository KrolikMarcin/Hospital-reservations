Rails.application.routes.draw do
  root 'appointments#index'
  get 'bills/not_paid', to: 'bills#not_paid'
  devise_for :users
  resources :reservations, shallow: true do
    get 'doctor_choice'
    patch 'doctor_choice_save'
  end
  resource :appointments do
    resources :bills
  end
end
