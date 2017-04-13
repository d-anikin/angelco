Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '*path', to: "admin/dashboard#index"
  root to: "admin/dashboard#index"
end
