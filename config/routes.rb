Rails.application.routes.draw do
  root to: 'pages#index'
  post '/result', to: 'pages#result'
end
