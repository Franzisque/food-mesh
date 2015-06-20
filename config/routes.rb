Food::Application.routes.draw do

    resources :daily_intakes

    root to: 'static_pages#index'

    scope '/:locale' do
        scope '/food/item' do
            # food item
            match '/:item_id', to: 'food_item#show', as: 'fetch_food_item', via: :get
            match '/add_to_basket/:item_id', to: 'user_session#add_items_to_basket', via: [:post, :get], as: 'add_item_to_basket'
            match '/delete_from_basket/:item_id', to: 'user_session#delete_item_from_basket', via: [:post, :get], as: 'delete_item_from_basket'
        end

        match '/delete_items_from_basket/', to: 'user_session#delete_all_items', via: [:post, :get], as: 'bulk_delete_basket'
        # search
        match '/search/:query', to: 'food_item#search', as: 'search_db', via: :get
        match '/compare', to: 'food_item#compare', as: 'compare_items', via: :get
    end

    match '/change/url/to/:locale(/:query)', to: 'application#change_lang', via: [:get, :post], as: 'change_lang'

    # user session
    get 'users/new', as: 'user_new'
    match '/user_session/change_user_settings', to: 'user_session#change_user_settings', via: [:post]
    get ':controller(/:action(/:id(.:format)))'

    # admin login actions
    scope '/admin' do
        resources :sessions, only: [:create, :destroy, :new]
        resources :users, only: [:index, :new, :create, :destroy]
        get '/' => 'sessions#new', :as => 'login'
        get '/logout' => 'sessions#destroy', :as => 'logout'
        get '/signup' => 'users#new', :as => 'signup'
        get '/dashboard' => 'admin_dashboard#index', as: 'dashboard'
        get '/delete/user/:user_id' => 'users#destroy', as: 'user_delete'
        get '/search/cache/clear' => 'food_item#clear_search_cache', as: 'clear_search_cache'
    end
end
