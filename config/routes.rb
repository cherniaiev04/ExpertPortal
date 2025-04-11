Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  match 'users/:id' => 'users#destroy', :via => :delete, :as => :admin_destroy_user
  resources :users, except: [:show]
  resources :categories, except: [:show]
  resources :course_modules, except: [:show]

  resources :experts do
    get 'me', on: :collection, to: 'experts#me'
  end
  resources :projects

  resources :invitations, only: %i[new create]
  get 'sign_up/:token', to: 'invitations#sign_up', as: 'sign_up_with_token'
  post 'sign_up/:token', to: 'invitations#create_user'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Routes for Progressive Web App (PWA) support
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest

  resources :experts do
    member do
      post :upload_cv
      post :upload_certificates
      delete :delete_cv
      delete :delete_certificate
    end
  end

  devise_scope :user do
    root to: 'users/sessions#new' # Now mapped correctly for the custom controller
  end
end
