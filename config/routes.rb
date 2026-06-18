Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions"
  }

  root to: "dashboard#index"

  # SDR Dialer
  resource :dialer, only: %i[show] do
    post :start_call
    post :end_call
    post :pause
    post :resume
    get  :timer_state
  end

  # Admin namespace
  namespace :admin do
    root to: "dashboard#index"

    resources :users, except: %i[destroy] do
      member do
        patch :activate
        patch :deactivate
      end
    end

    resources :imports, only: %i[index show create destroy] do
      member do
        get :status
      end
    end

    resources :leads, only: %i[index show update] do
      collection do
        post :redistribute
      end
      member do
        patch :reassign
      end
    end

    resource :kanban, only: %i[show] do
      patch :move, on: :collection
    end

    resources :audit_logs, only: %i[index show]

    resource :reports, only: %i[show] do
      get :export_csv,  on: :collection
      get :export_xlsx, on: :collection
    end

    resources :revenue_ranges, except: %i[destroy]
  end

  get "up", to: "rails/health#show", as: :rails_health_check
end
