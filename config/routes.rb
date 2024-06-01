Rails.application.routes.draw do
  devise_for :users

  resources :users, only: [:show] # マイページへのルーティング
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  root 'photos#index'
  get 'photos/top' => 'photos#top'

  resources :tags do
    get 'photos', to: 'photos#search'
  end

  resources :photos

end
