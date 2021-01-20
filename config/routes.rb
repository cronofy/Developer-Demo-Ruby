Rails.application.routes.draw do
  root to: 'calendars#index'
  
  get '/calendars/:id', to: 'calendars#show'
  post '/calendars/:id', to: 'calendars#create'

  get 'oauth2/callback', to: 'user#index'

end
