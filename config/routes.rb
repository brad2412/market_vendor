Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :markets, only: [:index, :show] do
        resources :vendors, only: [:index], controller: "markets/vendors"
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
