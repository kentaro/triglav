Hyperion::Application.routes.draw do
  root to: 'root#index'
  get '/caveat', to: 'root#caveat'

  get    '/signin' => redirect('/auth/github')
  delete '/signout', to: 'sessions#destroy'
  get    '/auth/:provider/callback', to: 'sessions#create'

  resources :services, constraints: { id: /[^\/]+/ }
  resources :roles,    constraints: { id: /[^\/]+/ }
  resources :hosts,    constraints: { id: /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/ }

  get '/activities', to: 'activities#index'
end
