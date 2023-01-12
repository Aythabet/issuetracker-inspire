Rails.application.routes.draw do
  get '/search', to: "issues#search"
  get '/home/index'
  get '/home/jira'

  resources :projects
  resources :issues
  resources :departements
  resources :owners
  resources :dailyreports


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
