PostitTemplate::Application.routes.draw do
  get "/login", to: 'sessions#new'
  post "/login", to: 'sessions#create'
  get "/logout", to: 'sessions#destroy'

  post "/avatar/:id", to: 'pictures#set_avatar', as: :avatar
  resources :pictures, only: [:new, :create, :show, :destroy]
  resources :comments, only: [:create, :destroy]
  get "/home", to: 'users#index'
  get "/register", to: 'users#new'
  resources :messages, only: [:show, :index, :destroy]
  resources :users, only: [:index, :new, :create, :show, :edit, :update] do
    resources :messages, only: [:new, :create]
    collection do
      get "search", to: "users#search"
      post "search_results", to: "users#search_results"
    end
    resources :questions, only: [:edit, :update]
    resources :posts, except: [:index] do
      resources :comments, only: [:create, :destroy]
    end
  end

  root to: 'pages#front'
end
