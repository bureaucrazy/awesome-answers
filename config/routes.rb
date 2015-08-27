Rails.application.routes.draw do
  resources :users, only: [:new, :create] do
    # get :hello # nested resource -> prepended with /users/:user_id
    # get :hello, on: :collection # not nested - doesn't include :id in url
    #                             # (similar to :new, :index, :create)
    # get :hello, on: :member     # not nested - includes :id in the url
    #                             # (very similar to :edit)

    # These two lines does the same as the do block below
    # get :edit, on: :collection
    # patch :update, on: :collection
    collection do
      get :edit
      patch :update
    end
  end
  resources :sessions, only: [:new, :create] do
    # this will create for us a route with DELETE http verb and /sessions
    # adding the on: :collection option will make it part of the routes for
    # sessions, which means it won't prepend the routes with /sessions/:session_id
    delete :destroy, on: :collection
  end

  patch "/questions/:id/lock" => "questions#lock", as: :lock_question

  # resources :answers
  # resources questions auto-generates all the routes below
  resources :questions do
    # nesting resources :answers in here makes every URL for answers prepended
    # with /questions/:question_id
    # resources():answers, {only: [:create, :destroy]}) # same as below
    resources :answers, only: [:create, :destroy]
  end

  # The only: [] will prevent creation of unneccessary routes
  resources :answers, only: [] do
    resources :comments, only: [:create, :destroy]
  end

  # post "/questions/:question_id/answers" =>  "answers#create"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # This will match any GET request to a url "/questions/new" to the Questions
  # controller and new action within that controller.
  # Adding the as: :new_question option enables us to have a handy URL helper
  # method that we can use in the views and controller.
  # The method in this case will be new_question path or new_question_url
  # get "/questions/new" => "questions#new", as: :new_question
  # post "/questions" => "questions#create", as: :questions      # => questions_path
  # get "/questions/:id" => "questions#show", as: :question
  # get "/questions" => "questions#index"
  # get "/questions/:id/edit" => "questions#edit", as: :edit_question
  # patch "/questions/:id" => "questions#update"
  # delete "/questions/:id"   => "questions#destroy"

  # this will match a GET request to "hello" url
  # it will invoke the index method (which is called action)
  # with in WelcomeController which is located in app/controllers folder
  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  get "/hello" => "welcome#index"
  get "/contact" => "contact#index"
  post "/contact" => "contact#create"

  get "/subscribe" => "subscribe#index"
  post "/subscribe" => "subscribe#create"

  # this will match any url /hello/something with GET request
  # in order to give a url a URL / PATH helper we provide it
  # with the as: option. The URL helper will be whatever you put
  # in there appended with _path or _url
  # When linking internally, you can use either, preferably PATH
  # when providing a link externally (such as in email), use URL
  # these helpers are accessible in the controller and the view files
  # URL - absolute link
  # PATH - relative link
  # When passing values to params through the url, the _path and _url
  # will not work normally. Need to use as: to get the values
  get "/hello/:name" => "welcome#hello", as: :greet

  get "/hello/:name/:city" => "welcome#hello", as: :full_greeting
  # this sets the home page. The helpers are: root_path and root_url
  root "welcome#index"

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
