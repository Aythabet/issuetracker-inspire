Rails.application.routes.draw do
  get '/search', to: "issues#search"
  get '/home/index'
  root "issues#index"

  resources :issues
  resources :projects
  resources :owners
  resources :departements
end
