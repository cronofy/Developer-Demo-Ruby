Rails.application.routes.draw do
  root to: 'users#index'
  
  get '/calendars/:id', to: 'calendars#show', as: 'calendar'
  post '/calendars/:id', to: 'calendars#create'

  get 'oauth2/callback', to: 'user#connect'

end
