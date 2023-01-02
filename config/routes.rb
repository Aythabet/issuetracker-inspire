Rails.application.routes.draw do
  get 'projects/index'
  get 'project/index'
  get '/search', to: "issues#search"
  root "issues#index"

  resources :issues
  resources :projects
  resources :owners
  resources :departements
end
