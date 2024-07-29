Rails.application.routes.draw do
  root "passwords#new"
  post "/", to: "passwords#create"
end