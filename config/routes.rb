Rails.application.routes.draw do
  root 'pages#home'

  get 'pages/home'
  get 'pages/contact'
  get 'pages/imprint'
  get 'pages/privacy'
  get 'pages/deleted'

  resources :events, only: [:show] do
    resource :reservation, only: [:create, :destroy]
    resource :notification, only: [:create, :destroy]
    resource :review
    resources :items, except: :show
    resources :labels, only: [:index, :create]
  end

  get 'events/:event_id/reserve', to: 'reservations#create', as: :event_reserve

  resource :seller do
    match :resend_activation, via: [:get, :post]
    member do
      post :mailing, action: :allow_mailing
      delete :mailing, action: :block_mailing
    end
  end

  get 'sellers/login/:token', to: 'sellers#login', as: :login_seller
  get 'sellers/register', to: redirect('/seller/new')

  namespace :admin do
    get '', controller: :pages, action: :home
    get 'items_per_category', controller: :pages, action: :items_per_category
    get 'items_per_day', controller: :pages, action: :items_per_day
    get 'sellers_per_day', controller: :pages, action: :sellers_per_day
    resources :events do
      resources :reviews, :reservations
      post 'messages/:action', to: 'messages#:action', as: :messages
    end
    resources :sellers
    resources :categories
    resources :reservations do
      resources :items do
        member do
          delete :code, action: :delete_code
        end
        collection do
          delete :codes, action: :delete_all_codes
          get :labels, action: :labels
          post :labels, action: :create_labels
        end
      end
    end
    get 'emails', controller: :emails
    post 'emails', controller: :emails, action: :create
    resource :user
    get 'login', controller: :sessions, action: :new
    post 'login', controller: :sessions, action: :create
    get 'logout', controller: :sessions, action: :destroy
  end

  namespace :api, defaults: { format: 'json' } do
    resource :event, only: [:show] do
      member do
        post :transactions
      end
    end
  end

  get '/pages/my_basar', to: redirect('http://flohmarkthelfer.de')
end
