PostitTemplate::Application.routes.draw do
  get "/login", to: 'sessions#new'
  post "/login", to: 'sessions#create'
  get "/logout", to: 'sessions#destroy'

  resources :comments, only: [:create, :destroy]
  get "/home", to: 'users#index'
  get "/register", to: 'users#new'
  resources :messages, only: [:show, :index, :destroy]
  get "/sent_messages", to: 'messages#sent'
  resources :users, only: [:index, :new, :create, :show, :edit, :update] do
    resources :messages, only: [:new, :create]
    collection do
      get "search", to: "users#search"
      post "search_results", to: "users#search_results"
    end
    resources :questions, only: [:edit, :update]
    resources :posts do
      resources :comments, only: [:create, :destroy]
    end
  end

  root to: 'pages#front'
end
