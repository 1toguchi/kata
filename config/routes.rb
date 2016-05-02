Rails.application.routes.draw do
  root :to => 'records#index', as: :root
  resources :records, except: :show
  get 'records/assoc' => 'records#assoc',as: :assoc
end
