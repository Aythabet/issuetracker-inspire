Rails.application.routes.draw do

  get '/search', to: "issues#search"
  get '/home/index'
  get '/home/jira'
  get '/home/issues'

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
    root to: 'home#index', as: :authenticated_root
  end

  root to: redirect('/users/sign_in')

end
