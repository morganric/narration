Rails.application.routes.draw do

  get "pages/about" => "pages#about", as: :about
  get "author/:author" => "posts#author", as: :author
  get "provider/:provider" => "posts#provider", as: :provider
  get "featured" => "posts#featured", as: :featured

  resources :profiles
  get '/tagged/:tag', to: 'posts#tag', via: [:get, :post], :as => :tag
  post '/posts/:id/play' => 'posts#plays', as: :post_play
  get '/:user_id/:id/embed', :to => "posts#embed", as: :embed
  get '/:user_id/:id/popout', :to => "posts#popout", as: :popout

  resources :posts

  mount Upmin::Engine => '/admin'

  devise_for :users
  resources :users


  scope ":id" do
    get '/', to: 'profiles#show', :as =>  :vanity_profile
    
  end

  get '/:user_id/:id', to: 'posts#show', :as =>  :user_post


    root to: 'posts#index'

end
