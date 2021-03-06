Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

    root 'static_pages#home'

    get "about" => 'static_pages#about'

    get "video" => "videos#show"

    get "video_categories" => 'videos#categories'

    get "top_videos" => "videos#index"

    get 'image' => "images#show"

    get "top_images" => "images#index"

    get 'image_categories' => "images#categories"

    delete 'logout' => "sessions#destroy"

    get 'login' => 'sessions#new'

    post 'login' => "sessions#create"

    get 'random_video' => "videos#random"

    get 'random_image' => "images#random"

    resources :videos, only: [:create, :destroy]

    resources :images, only: [:create, :destroy]

    resources :users do
      resources :favorite_videos
      resources :favorite_images
      resources :unmotivational_videos
      resources :unmotivational_images
    end

    resources :user_submitted_motivations

    get "submit" => 'user_submitted_motivations#new'


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
