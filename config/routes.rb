Rails.application.routes.draw do

  
  resources :listens
  mount Upmin::Engine => '/admin'

  get "pages/about" => "pages#about", as: :about
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

  resources :posts


  devise_for :users
  resources :users


  scope ":id" do
    get '/', to: 'profiles#show', :as =>  :vanity_profile
    
  end

  get '/:user_id/:id', to: 'posts#show', :as =>  :user_post


  authenticated :user do
    root to: "posts#index", as: :authenticated_root
  end

  unauthenticated do
    root to: "posts#featured"
  end

end
