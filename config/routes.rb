# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users

  match 'application/*args' => 'error#unhandled_request', via: :all
  match 'application' => 'error#unhandled_request', via: :all

  # install the default route as the lowest priority.
  match '/:controller(/:action(/:id))', via: :all
  # match ':controller/:action.:format'
  match '*anything' => 'error#unhandled_request', via: :all
end
