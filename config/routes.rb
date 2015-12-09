Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
