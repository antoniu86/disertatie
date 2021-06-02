Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # install the default route as the lowest priority.
  match '/:controller(/:action(/:id))', via: :all
  # match ':controller/:action.:format'
  match '*anything' => 'error#unhandled_request', via: :all
end
