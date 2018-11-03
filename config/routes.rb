Rails.application.routes.draw do
  root 'top#index'
  get 'edit_problems' => 'top#edit_aoj', as: :edit_aoj
  post 'update_problems' => 'top#update_aoj', as: :update_aoj
  get 'about'  => 'top#about', as: 'about'
  get 'login' => 'sessions#new', as: 'new_login'
  post 'login' => 'sessions#create', as: 'login'
  delete 'logout' => 'sessions#destroy', as: 'logout'

  resources :users

  namespace :admin do
    root to: 'problems#index'
    resources :users
    resources :problems
  end

  match '*anything' => 'top#not_found', via: [:get, :post, :patch, :delete]
end
