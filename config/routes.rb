require "resque_web"
Messaging::Application.routes.draw do
  devise_for :users
  resources :rules

  resources :groups

  resources :contacts

  resources :deliverables

  resources :sms
  resources :emails
  resources :accountings

  resources :controls

  resources :customers

  match '/responses' => SmsResponse, :anchor => false, :via => :get

  match 'rules/:id/deactivate', to: 'rules#deactivate', :as => 'deactivate_rule', :via => :get
  match 'rules/:id/activate', to: 'rules#activate', :as => 'activate_rule', :via => :get
  root 'customers#index'

  mount ResqueWeb::Engine => "/scheduler"
  ResqueWeb::Engine.eager_load!
end
