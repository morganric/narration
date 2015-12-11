Rails.application.routes.draw do

  resources :profiles
  get '/tagged/:tag', to: 'posts#tag', via: [:get, :post], :as => :tag

  resources :posts

  mount Upmin::Engine => '/admin'

  devise_for :users
  resources :users


  scope ":id" do
    get '/', to: 'profiles#show', :as =>  :vanity_profile
    
  end

    root to: 'posts#index'

end
