Rails.application.routes.draw do
  resources :campaigns, only: [:index, :show, :create, :update, :destroy] do
    resources :nodes, only: [:create, :show, :update, :destroy]
    resources :conditions, only: [:create, :update, :destroy]
  end
  resources :user_activities, only: [:create]
end
