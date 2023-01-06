Rails.application.routes.draw do
  get '/search', to: "issues#search"
  get '/home/index'
  root "projects#index"

  resources :projects
  resources :issues
  resources :owners
  resources :departements
end
