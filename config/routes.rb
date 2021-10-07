Rails.application.routes.draw do
  get 'checks/full_report'
  get 'about', to: 'pages#about'
  get 'glossary', to: 'pages#glossary'
  get 'landing', to: 'pages#landing'
  get 'healthcheck', to: 'pages#healthcheck'
  devise_for :users, controllers: { registrations: 'registrations' }

  root to: 'pages#home'

  resources :checks do
    resources :vulnerabilities, only: %i[new create]
    get 'full-report'
  end

  resources :users, only: %i[edit update]


end
