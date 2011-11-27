Dummy::Application.routes.draw do
  resources :users, :only => [:index]
  
  # root :to => "welcome#index"
end
