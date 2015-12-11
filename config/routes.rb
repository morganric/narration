Rails.application.routes.draw do
  resources :posts
  mount Upmin::Engine => '/admin'
  root to: 'posts#index'
  devise_for :users
  resources :users
end
