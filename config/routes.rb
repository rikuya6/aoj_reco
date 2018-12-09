Rails.application.routes.draw do
  root 'top#index'
  get 'about'  => 'top#about', as: 'about'

  namespace :admin do
    root to: 'sessions#new'
    get 'login' => 'sessions#new', as: 'new_login'
    post 'login' => 'sessions#create', as: 'login'
    delete 'logout' => 'sessions#destroy', as: 'logout'
    resource :settings, only: [:edit, :update]
    resources :users
    resources :problems
  end

  match '*anything' => 'top#not_found', via: [:get, :post, :patch, :delete]
end
