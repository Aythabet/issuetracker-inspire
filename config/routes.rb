Rails.application.routes.draw do
  get 'projects/index'
  get 'project/index'
  root "issues#index"

  resources :issues
  resources :projects
  resources :owners
  resources :departements
end
