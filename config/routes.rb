Rails.application.routes.draw do

  get "pages/about" => "pages#about", as: :about
  resources :profiles
  get '/tagged/:tag', to: 'posts#tag', via: [:get, :post], :as => :tag
  post '/posts/:id/play' => 'posts#plays', as: :post_play
  get '/:user_id/:id/embed', :to => "posts#embed", as: :embed

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
