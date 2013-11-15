PostitTemplate::Application.routes.draw do
  get "/login", to: 'sessions#new'
  post "/login", to: 'sessions#create'
  get "/logout", to: 'sessions#destroy'

  resources :comments, only: [:create, :destroy]
  get "/home", to: 'users#index'
  get "/register", to: 'users#new'
  resources :users, only: [:index, :new, :create, :show, :edit, :update] do
    collection do
      post "search", to: "users#search"
    end
    resources :questions, only: [:edit, :update]
    resources :posts
  end

  root to: 'pages#front'
end
