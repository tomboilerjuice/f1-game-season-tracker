Rails.application.routes.draw do
  resources :race
  post 'race/new', to: 'race#create', as: :create_race
  get 'home/index'
  get 'home/index_auth'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
root 'home#index'
end
