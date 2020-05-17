Rails.application.routes.draw do
  root "welcome#index"
  resource :session, only: [:show, :create, :destroy]
end
