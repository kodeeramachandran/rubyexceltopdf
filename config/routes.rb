Rails.application.routes.draw do
  root :to => 'converts#index'
  match '/',:to => 'converts#create',via: [:post]
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
