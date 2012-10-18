Hyperion::Application.routes.draw do
  root to: 'root#index'
  get '/caveat', to: 'root#caveat'

  get    '/signin' => redirect('/auth/github')
  delete '/signout', to: 'sessions#destroy'
  get    '/auth/:provider/callback', to: 'sessions#create'

  concern   :revertable do member { put 'revert' } end
  resources :services, constraints: { id: /[^\/]+/ }, concerns: :revertable
  resources :roles,    constraints: { id: /[^\/]+/ }, concerns: :revertable
  resources :hosts,    constraints: { id: /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/ }, concerns: :revertable

  get '/activities', to: 'activities#index'

  get '/api/service/:service/:action', controller: 'api'
  get '/api/service/:service/role/:role/:action', controller: 'api'
end

