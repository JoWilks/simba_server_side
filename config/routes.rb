Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/users', to: 'users#index'
      get '/validate', to: 'users#validate'
      post '/login', to: 'auth#create'
      post '/register', to: 'users#create'
      
      get '/categories', to: 'categories#index'
      get '/categories', to: 'categories#show'
      post '/categories', to: 'categories#create'
      put '/categories', to: 'categories#update'
    end
  end

  #Route to acquire access token

end
