Triglav::Application.routes.draw do
  root to: 'root#index'
  get '/caveat', to: 'root#caveat'

  get    '/signin' => redirect('/auth/github')
  delete '/signout', to: 'sessions#destroy'
  get    '/auth/:provider/callback', to: 'sessions#create'

  concern :revertable do member { put 'revert' } end
  concern :commentable do
    resources :comments, only: [:create]
  end

  resources :services, constraints: { id: /[^\/\.]+/ }, concerns: [:revertable, :commentable]
  resources :roles,    constraints: { id: /[^\/\.]+/ }, concerns: [:revertable, :commentable]
  resources :hosts,    constraints: { id: /[^\/\.]+/ }, concerns: [:revertable, :commentable]

  get '/activities', to: 'activities#index'

  scope '/api' do
    resources :services, constraints: { id: /[^\/\.]+/ }, only: %w(index show)
    resources :roles   , constraints: { id: /[^\/\.]+/ }, only: %w(index show)
    resources :hosts   , constraints: { id: /[^\/\.]+/ }, only: %w(index show)

    get '/services/:service/:action', controller: 'api'
    get '/services/:service/roles/:role/:action', controller: 'api'
  end
end
