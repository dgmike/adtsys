Rails.application.routes.draw do
  root to: 'home#index'
  get "/" => "home#index"
  get "/models" => "models#index"
end
