PostitTemplate::Application.routes.draw do
  get "/login", to: 'sessions#new'
  post "/login", to: 'sessions#create'
  get "/logout", to: 'sessions#destroy'

  get "/register", to: 'users#new'
  resources :users, only: [:index, :new, :create]

  root to: 'users#index'
end
