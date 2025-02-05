Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :schedules, only: [ :index, :create, :update, :destroy, :show ] do
    member do
      patch :confirm
    end
    collection do
      get :available
    end
  end
end
