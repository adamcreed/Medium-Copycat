Rails.application.routes.draw do
  resources :marks, except: :delete
  resources :articles do
    resources :comments
  end

  resources :sources

  delete '/marks', to: 'marks#destroy'
  get '/search/articles', to: 'search#articles'
  get '/search/sources', to: 'search#sources'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
