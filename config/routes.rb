Rails.application.routes.draw do
  root 'pages#home'

  get 'pages/home'
  get 'pages/contact'
  get 'pages/imprint'
  get 'pages/privacy'
  get 'pages/deleted'

  # mount RailsAdmin::Engine => '/manager', as: :rails_admin

  resources :events do
    resource :reservation, only: [:create, :destroy]
    resource :notification, only: [:create, :destroy]
    resource :review
    resources :items, except: :show
    resources :labels, only: [:index, :create]
  end

  resource :seller do
    match :resend_activation, via: [:get, :post]
    member do
      post :mailing, action: :allow_mailing
      delete :mailing, action: :block_mailing
    end
  end

  get 'sellers/login/:token', to: 'sellers#login', as: :login_seller
  get 'sellers/reserve/:token/:event_id', to: 'sellers#reserve', as: :reserve_seller

  namespace :admin do
    get '', controller: :pages, action: :home
    resources :events do
      resources :reviews, :reservations
    end
    resources :sellers
    resources :categories
    resources :reservations do
      resources :items
    end
    get 'emails', controller: :emails
    post 'emails', controller: :emails, action: :create
    get 'password', controller: :pages, action: :password
  end
end
