Rails.application.routes.draw do

  
  resources :listens
  mount Upmin::Engine => '/admin'
  mount Maktoub::Engine => '/news'

  get "pages/about" => "pages#about", as: :about
  get "pages/welcome" => "pages#welcome", as: :welcome
  get "author/:author" => "posts#author", as: :author
  get "provider/:provider" => "posts#provider", as: :provider
  get "featured" => "posts#featured", as: :featured
  get "latest" => "posts#latest", as: :latest

  resources :profiles
  get '/tagged/:tag', to: 'posts#tag', via: [:get, :post], :as => :tag
  post '/posts/:id/play' => 'posts#plays', as: :post_play
  get '/:user_id/:id/embed', :to => "posts#embed", as: :embed
  get '/:user_id/:id/popout', :to => "posts#popout", as: :popout
  get '/:user_id/:id/player', :to => "posts#player", as: :player
    get '/:user_id/:id/miniembed', :to => "posts#miniembed", as: :miniembed

  resources :posts

  get "posts/:id/download", :to => 'posts#download', as: :post_download


  devise_for :users
  resources :users


  scope ":id" do
    get '/', to: 'profiles#show', :as =>  :vanity_profile
    get '/about', to: 'profiles#about', as: :about_profile
    get '/listens', to: 'profiles#listens', as: :listens_profile
    
  end

  get '/:user_id/:id', to: 'posts#show', :as =>  :user_post


  authenticated :user do
    root to: "posts#index", as: :authenticated_root
  end

  unauthenticated do
    root to: "pages#welcome"
  end

end
