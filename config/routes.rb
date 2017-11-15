Rottenpotatoes::Application.routes.draw do
  root :to =>redirect('/movies')
  resources :movies do
    member do
      get 'similar'
    end
  end
end
