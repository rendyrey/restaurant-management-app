# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  # get "otp/new"
  # get "otp/create"
  # devise_for :staffs
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  mount Sidekiq::Web => "/sidekiq"

  namespace :api do
    namespace :v1 do
      scope "customers" do
        get "frequent" => "customers#frequent_customers"
        post "upload_csv" => "customers#upload_csv"
      end

      scope "reservations" do
        get "today" => "reservations#confirmed_reservations"
        post "book" => "reservations#book_table"
      end
    end
  end

  devise_for :staffs, controllers: { sessions: "staffs/sessions" }
  resources :otp, only: [:new, :create] do
    post :resend, on: :collection
  end
end
