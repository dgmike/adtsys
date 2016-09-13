Rails.application.routes.draw do
  get "/" => "home#index"

  get "/models" => "models#index"
end
