Rails.application.routes.draw do

  get '/search', to: "issues#search"
  get '/home/index'

  resources :projects
  resources :issues
  resources :owners
  resources :departements

  # Devise routes
  devise_scope :user do
    get "users", to: "devise/sessions#new"
  end

  devise_for :users
  authenticated :user do
    root to: 'projects#index', as: :authenticated_root
  end
  root to: redirect('/users/sign_in')

end
