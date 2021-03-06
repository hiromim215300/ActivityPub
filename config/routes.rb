Rails.application.routes.draw do
  devise_for :users

  root to: 'activities#index'

  get 'activities', to: redirect('/')
  resources :actors, only: [:index, :show] do
    collection do
      get :lookup, to: 'actors#lookup'
    end
    resources :activities, only: [:index]
  end
  get :feed, to: 'activities#feed'

  resources :notes
  resources :users, except: [:new, :create, :destroy]

  get '/.well-known/webfinger', to: 'web_finger#find', as: :webfinger
  get '/.well-known/host-meta', to: 'web_finger#host_meta', as: :host_meta
  get '/.well-known/nodeinfo', to: 'web_finger#node_info', as: :node_info
  get '/nodeinfo/2.0', to: 'web_finger#show_node_info', as: :show_node_info

  namespace :federation do
    resources :actors, only: [:show] do
      get :outbox, to: 'activities#outbox'
      post :inbox, to: 'activities#create'
      resources :activities, only: [:show]
      resources :notes, only: [:show]
    end
  end
end
