Rails.application.routes.draw do
  devise_scope :user do
    get "users", to: "devise/sessions#new"
  end

  devise_for :users
  get '/search', to: "issues#search"
  get '/home/index'
  root "projects#index"

  resources :projects
  resources :issues
  resources :owners
  resources :departements
end
