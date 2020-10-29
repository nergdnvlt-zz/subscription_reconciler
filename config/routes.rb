Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'subs#index'

  resources :webhooks, only: %w[index show]

  namespace 'api' do
    namespace 'v1' do
      post '/fastspring', to: 'fastspring#create'
    end
  end

  get '/:slug', to: 'subs#show'
end
