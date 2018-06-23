Rails.application.routes.draw do
  root 'pages#home'

  post 'mail', to: 'mail#receive', as: :receive_mail

  get 'pages/home'
  get 'pages/index'
  get 'pages/contact'
  get 'pages/imprint'
  get 'pages/privacy'
  get 'pages/terms'
  get 'pages/deleted'

  resources :events, only: [:show] do
    member do
      get :review
      get :reserve
    end

    resources :reservations, only: %i[create destroy edit update] do
      resources :items, except: :show do
        member do
          delete :code, action: :delete_code
        end
      end
      resources :labels, only: %i[index create]
      resource :review
    end

    get 'reservations/create', to: 'reservations#create'

    resource :notification, only: %i[create destroy]
  end

  resource :seller do
    match :resend_activation, via: %i[get post]
    member do
      post :mailing, action: :allow_mailing
      delete :mailing, action: :block_mailing
    end
  end

  get 'sellers/login/:token', to: 'sellers#login', as: :login_seller
  post 'sellers/login/:token', to: 'sellers#reenter', as: :reenter_seller
  get 'sellers/register', to: redirect('/seller/new')

  namespace :admin do
    get '', controller: :pages, action: :home
    resources :events, except: :destroy do
      resources :reviews
      resources :reservations do
        collection do
          get :new_bulk
          post :create_bulk
        end
      end
      resources :suspensions
      resources :rentals
      post 'messages/:action', to: 'messages#:action', as: :messages
      member do
        get :stats
        get :data
        get :bill
      end
    end
    resource :client, only: [:edit, :update]

    resources :sellers do
      resources :emails, only: [:index, :show]
    end
    resources :categories do
      resources :sizes
    end
    resources :stock_items do
      collection do
        get :print, action: :print
      end
    end
    resources :message_templates, only: %i[index edit update destroy]
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

  get '*unmatched_route', to: 'application#not_found'
end
