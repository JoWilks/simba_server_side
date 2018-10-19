Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/users', to: 'users#index'
      get '/validate', to: 'users#validate'
      post '/login', to: 'auth#create'
      post '/register', to: 'users#create'

      post '/exchange', to: 'users#exchange'
      get '/refresh', to: 'users#refresh'
      
      get '/categories/:id', to: 'categories#show'
      get '/categories', to: 'categories#index'
      post '/categories/base', to: 'categories#createbase'
      post '/categories', to: 'categories#create'
      put '/categories', to: 'categories#update'
    end
  end

  #Route to acquire access token

end
