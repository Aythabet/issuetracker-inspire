Rails.application.routes.draw do
  get '/search', to: "issues#search"
  root "home#index"

  resources :issues
  resources :projects
  resources :owners
  resources :departements
end
