# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  root to: 'home#index'

  devise_scope :user do
    post '/register', to: 'users/registrations#create'
  end

  devise_for :users, path: "", controllers: {sessions: "users/sessions", registrations: "users/registrations", passwords: "users/passwords"}, path_names: { sign_in: 'login', password: 'forgot', confirmation: 'confirm', unlock: 'unblock', sign_up: 'register', sign_out: 'signout'}

  match 'profile(/:username)' => 'profile#profile', via: :get

  match 'application/*args' => 'error#unhandled_request', via: :all
  match 'application' => 'error#unhandled_request', via: :all

  # install the default route as the lowest priority.
  match '/:controller(/:action(/:id))', via: :all
  # match ':controller/:action.:format'
  match '*anything' => 'error#unhandled_request', via: :all
end
