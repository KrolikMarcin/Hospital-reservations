Rails.application.routes.draw do
  root 'reservations#index'
  devise_for :users
  
  resources :patients, only: [:index, :show]
  resources :reservations, :staffs
  
  end 
    

  
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
