PostitTemplate::Application.routes.draw do
  get "/login", to: 'sessions#new'
  post "/login", to: 'sessions#create'
  get "/logout", to: 'sessions#destroy'

  get "/home", to: 'users#index'
  get "/register", to: 'users#new'
  resources :users, only: [:index, :new, :create, :show, :edit, :update] do
    resources :questions, only: [:edit, :update]
  end
  root to: 'pages#front'
end
