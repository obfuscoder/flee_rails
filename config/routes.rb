Rails.application.routes.draw do
  root 'pages#home'

  get 'pages/home'
  get 'pages/contact'
  get 'pages/imprint'
  get 'pages/privacy'
  get 'pages/deleted'

  # mount RailsAdmin::Engine => '/manager', as: :rails_admin

  resources :items, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :labels, only: [:index, :create]
  resources :events do
    resource :reservation, only: [:create, :destroy]
    resource :notification, only: [:create, :destroy]
    resource :review
  end

  resource :seller do
    match :resend_activation, via: [:get, :post]
    member do
      post :mailing, action: :allow_mailing
      delete :mailing, action: :block_mailing
    end
  end

  get 'sellers/login/:token', to: 'sellers#login', as: :login_seller

  namespace :admin do
    get '', controller: :pages, action: :home
    resources :events do
      resources :reservations, :reviews
    end
    resources :sellers, :categories
    get 'mails', controller: :mails
    get 'password', controller: :pages, action: :password
  end
end
