Rails.application.routes.draw do
  resources :campaigns, only: [:index, :show, :create, :update] do
    resources :nodes, only: [:create, :show, :update, :destroy]
  end
end
