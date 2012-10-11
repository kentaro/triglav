Hyperion::Application.routes.draw do
  root to: 'Root#index'
  get  '/caveat', to: 'Root#caveat'

  get    '/signin' => redirect('/auth/github')
  delete '/signout', to: 'sessions#destroy'
  get    '/auth/:provider/callback', to: 'sessions#create'
end
