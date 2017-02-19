Rails.application.routes.draw do
  resources :marks, except: :delete
  resources :articles do
    resources :comments
  end

  resources :sources

  delete '/marks', to: 'marks#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
