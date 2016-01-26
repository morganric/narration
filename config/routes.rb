Rails.application.routes.draw do

  get "hot" => "posts#hot", as: :hot

  post "/search" => "posts#search", as: :search
  get "/search" => "posts#search"
  get "settings" => "settings#index", as: :settings
  get "settings/edit" => "settings#edit", as: :settings_edit
  put "settings" => "settings#update", as: :settings_update

  resources :listens
  mount Upmin::Engine => '/admin'
  mount Maktoub::Engine => '/news'

  get "about" => "pages#about", as: :about
  get "feedback" => "pages#feedback", as: :feedback
  get "welcome" => "pages#welcome", as: :welcome
  get "author/:author" => "posts#author", as: :author
  get "provider/:provider" => "posts#provider", as: :provider
  get "featured" => "posts#featured", as: :featured
  get "latest" => "posts#latest", as: :latest


  resources :profiles
  get '/tagged/:tag', to: 'posts#tag', via: [:get, :post], :as => :tag
  post '/posts/:id/play' => 'posts#plays', as: :post_play
  get '/embed/:id', :to => "posts#embed", as: :embed
    get '/:user_id/:id/embed', :to => "posts#embed", as: :oldembed
  get '/:user_id/:id/preview', :to => "posts#preview", as: :preview
  get '/:user_id/:id/popout', :to => "posts#popout", as: :popout
  get '/:user_id/:id/player', :to => "posts#player", as: :player
  get '/:user_id/:id/miniembed', :to => "posts#miniembed", as: :miniembed
  get '/oembed', :to => "posts#oembed", as: :oembed

  resources :posts

  get "posts/:id/download", :to => 'posts#download', as: :post_download
  get "p/:id", :to => 'posts#short', as: :short

  post 'user_favs' => 'user_favs#create', :as => 'user_favs'
  delete 'user_favs' => 'user_favs#destroy', :as => 'delete_user_favs'


 devise_for :users, controllers: { registrations: "users/registrations" }
  resources :users


  scope ":id" do
    get '/', to: 'profiles#show', :as =>  :vanity_profile
    get '/about', to: 'profiles#about', as: :about_profile
    get '/listens', to: 'profiles#listens', as: :listens_profile
    get '/favorites', to: 'profiles#favorites', as: :user_favorites
    
  end

  get '/:user_id/:id', to: 'posts#show', :as =>  :user_post


  authenticated :user do
    root to: "posts#index", as: :authenticated_root
  end

  unauthenticated do
    root to: "posts#index"
  end

end
