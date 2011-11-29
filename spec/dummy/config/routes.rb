Dummy::Application.routes.draw do
  resources :users, :only => [:index, :show]
  
  root :to => 'users#index'
end
