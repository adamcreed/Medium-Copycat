Rails.application.routes.draw do
  resources :marks
  resources :articles do
    resources :comments
  end
  
  resources :sources
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
