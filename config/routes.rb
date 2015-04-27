Rails.application.routes.draw do
  root 'pages#home'

  get 'pages/home'
  get 'pages/contact'
  get 'pages/imprint'
  get 'pages/privacy'

  mount RailsAdmin::Engine => '/admin', as: :rails_admin

  resources :reserved_items
  resources :reservations
  resources :items, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :categories
  resources :events do
    resource :reservation
    resource :notification, only: [:create, :destroy]
    resource :review
  end

  resource :seller do
    match :resend_activation, via: [:get, :post]
    member do
      post :mail, to: :enable_mail, as: :enable_mail
      delete :mail, to: :disable_mail, as: :disable_mail
    end
  end

  get 'sellers/login/:token', to: 'sellers#login', as: :login_seller
end
