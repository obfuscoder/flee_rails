Rails.application.routes.draw do
  root 'pages#home'

  post 'mail', to: 'mail#receive', as: :receive_mail

  get 'pages/home'
  get 'pages/index'
  get 'pages/imprint'
  get 'pages/privacy'
  get 'pages/terms'
  get 'pages/deleted'

  get 'contact/show'
  post 'contact/submit'
  get 'contact/submitted'

  resources :events, only: [:show] do
    member do
      get :review
      get :reserve
    end

    get :support, to: 'support#index'
    get 'support/:id/new', to: 'support#new', as: :new_support
    post 'support/:id', to: 'support#create', as: :create_support
    delete 'support/:id', to: 'support#destroy', as: :destroy_support

    resources :reservations, only: %i[create destroy] do
      resources :items, except: :show do
        member do
          delete :code, action: :delete_code
        end
      end
      member do
        get :import
        post :import
      end
      get 'import/:id', to: 'reservations#import_from', as: :import_from

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
      resources :support_types do
        collection do
          get :print
        end
        resources :supporters
      end
      resources :messages, only: [] do
        collection do
          post :invitation
          post :reservation_closing
          post :reservation_closed
          post :finished
        end
      end
      member do
        get :stats
        get :data
        get :bill
        get :report
        get :labels
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
  get '*unmatched_route', to: 'application#not_found'
end
