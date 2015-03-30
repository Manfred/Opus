Rails.application.routes.draw do
  root to: 'books#index'
  resources :books

  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end
end
