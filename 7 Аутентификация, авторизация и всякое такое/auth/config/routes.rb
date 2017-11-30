Rails.application.routes.draw do
  get 'session/login'

  post 'session/create'

  get 'session/logout'

  resources :users
  root to: 'lr8_logic#input'

  get 'lr8_logic/input'

  get 'lr8_logic/output'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
