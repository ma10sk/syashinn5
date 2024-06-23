Rails.application.routes.draw do
  devise_for :users

  get 'users/top', to: 'users#top', as: :users_top

  resources :users, only: [:show] # マイページへのルーティング
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  root 'photos#index'
  get 'photos/top' => 'photos#top'
  delete 'photos/top' => 'photos#destroy_tag', as: :destroy_tag

  resources :tags do
    get 'photos', to: 'photos#search'
  end

  resources :photos

end