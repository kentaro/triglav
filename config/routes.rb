Hyperion::Application.routes.draw do
  root  to: 'Root#index'
  match '/caveat', to: 'Root#caveat'

  match '/signin' => redirect('/auth/github')
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/auth/:provider/callback', to: 'sessions#create'
end
