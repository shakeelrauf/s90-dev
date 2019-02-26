Rails.application.routes.draw do
  root :to => "web#index"
  get 'home' => 'home#index'
  scope :google, controller: :google_authentication do
    get :redirect, action: :auth, as: :redirect
    get :callback, action: :callback, as: :callback
    get :calendars, action: :calendars, as: :calendars
    scope :events do
      get ':calendar_id', action: :events, as: :events, calendar_id: /[^\/]+/
    end
  end

  namespace :admin do
    resources :playlists
  end


  namespace :client do
    post :like, controller: :dashboard, action: :like
    post :dislike, controller: :dashboard, action: :dislike
    root to: 'security#sign_in'
    get 'login' => "security#sign_in"
    get 'set_coords' => "security#set_coords"
    get 'sign_up' => "security#sign_up"
    get 'dashboard' => "dashboard#dashboard"
    get 'my_artists' => "dashboard#my_artists"
    get 'my_playlists' => "dashboard#my_playlists"
    get 'my_songs' => "dashboard#my_songs"
    get "profile" => "dashboard#get_profile"
    resources :artist,param: :id, only: [:show] do
      member do
        get :artist_overview
        get :albums
        get :top_songs
        get :playlists
      end
    end
    get 'splash' => "dashboard#splash"
    resources :songs, only: [] do
      collection do
        post :playable_url
        post :playlistlike
        post :playlistdislike
        post :create_playlist
        post :add_to_playlist
        post :sticky_player
        get :top_songs
        get :my_session
      end
    end
    post '/sign_up' => "security#create"
    get "logout" => "security#logout"
    post "/login" => "security#login"
    get 'search' => "dashboard#search"
    resources :events do
      collection do
        get :all_events
        post :like
        post :dislike
      end
    end
    resources :albums, only: [:show,:index] do
      member do
        get :songs
      end
      collection do
        get :album_playlist
      end
    end
    #Clients routes placed here...
  end


  
  # namespace :admin do
    resources :tour_dates
    resources :venues
    resources :tours do
      post "/del_tour",  action: :del_tour
    end
  # end

  #
  # scope :admin, controller: :admin do
  #   match  ':actp', action: :act,                via: [:get, :post]
  #   match  ':actp/:pid/:oid', action: :act,      via: [:get, :post]
  # end
  #
  # Remove depreciated error.
  # scope :admin , controller: :admin do
  #   %w(artists
  #   managers
  #   all
  #   artist_new
  #   manager_new
  #   admin_required
  #   artist_save
  #   reinitialize_password
  #   i18n_files
  #   i18n_table
  #   artist
  #   validate_email
  #   person_create
  #   artist_invite
  #   i18n_save).each do |action|
  #     get action, action: action
  #     get "#{action}/:pid/oid", action: action
  #     post action, action: action
  #     post "#{action}/:pid/oid", action: action
  #   end
  # end


  # Artists
  get :a , action: :index, controller: :artist
  scope  :a , controller: :artist do
    post :s , action: :search, defaults: { format: 'json' }
    post :sp , action: :send_pic, defaults: { format: 'json' }
    post :sp_base , action: :send_pic_base64, defaults: { format: 'json' }
    post :rp , action: :remove_pic, defaults: { format: 'json' }
  end
  scope controller: :store, path: :store do
    post :create_qr
    get :codes
  end
  # Admin
  # get :ad ,action: :artists, controller: :admin
  scope  :ad , controller: :admin do
    post :artist_new
    get  :artists
    get  :artist_new
    get  :artist_invite
    get  :manager_new
    post :artist_save , defaults: { format: 'json' }
    get  :artists
    get  :managers
    get  :all
    # get  :i18n_files
    scope :i18n_files do
      get '', action: :i18n_files
      get ':fn', action: :i18n_files
    end
    post :i18n_table

    scope :person do
      %w(artists
      managers
      all
      suspend_artist
      suspended_artist
      artist_new
      manager_new
      admin_required
      artist_save
      reinitialize_password
      i18n_files
      i18n_table
      artist
      validate_email
      person_create
      artist_invite
      i18n_save).each do |a|
        get a, action: a
        get "#{a}/:pid/oid", action: a
        post a, action: a
        post "#{a}/:pid/oid", action: a
      end
    end
    #   get  ':action', action: :artist
    #   post ':action', action: :artist
    # end
  end
  #admin


  # Manager
  get :manager ,action: :artists, controller: :manager
  scope  :manager , controller: :manager do
    post :artist_new
    get  :artist_invite
    get  :artist_new, as:  :manager_artist_new
    post :artist_save , defaults: { format: 'json' }
    get  :artists, as: :manager_artists
    scope :person do
      post :person_create
      get  ':pid', action: :artist
      post ':pid', action: :artist
    end
  end
  scope :images, controller: :images do
    get 'default/:ot/:oid/:img_id', as: :default_imag, action: :default_image
    post :del_img, action: :del_img
    post :get_profiles, action: :get_profiles
  end
  get :get_covers, action: :get_covers, controller: :images
  get :get_profile_pics, action: :get_profile_pics, controller: :images


  # Album
  scope :al , controller: :album do
    post :sn, action: :song_names, defaults: { format: 'json' }
    post :send_cover,  defaults: { format: 'json' }
    post 'send_cover/:id', action: :send_cover, defaults: { format: 'json' }
    post :rem_cover,   defaults: { format: 'json' }
    post :send_songs,  defaults: { format: 'json' }
    post :remove_song, defaults: { format: 'json' }
    post :remove_album, defaults: { format: 'json' }
    post :suspend_album, defaults: { format: 'json' }

    scope :cover do
      get ':pid/:alid', action: :cover
    end
    scope :my do
      get ':pid', action: :my
    end
    scope :s do
      get ':pid/:alid', action: :songs
      post ':pid/:alid', action: :songs
    end
  end
  scope :album, controller: :album do
    get ':actp/:pid', action: :index
    post ':actp/:pid', action: :index
  end

  scope :auth , controller: :omni_authications do
    scope ':provider' do
      get :callback
      get :callback2
      post :callback
      post :callback2
    end
  end

  scope :st, controller: :stream do
    get :co, action: :convert_one, defaults: { format: 'json' }
    get 'sos/:sid', action: :stream_one_song
  end

  scope :p, controller: :person do
    get :p , action: :profile
    scope :p do
      get ':pid', action: :profile, as: :profil
    end
  end
  scope  :s , controller: :shared do
    get :t , action: :token
  end
  # Mobile...

  # match 'al/asn', to: 'album#album_song_names', defaults: { format: 'json' },   via: [:post]

  # match 'al/up', to: 'album#upload',                                            via: [:get]
  # match 'al/sos', to: 'album#stream_one_song', defaults: { format: 'json' },    via: [:get]
  # match 'st/sos', to: 'stream#stream_one_song',                                 via: [:get]

  # match 'al/test_aws', to: 'album#test_aws', defaults: { format: 'json' },      via: [:get]


  # Mobile
  scope :search , controller: :search do
    post :search, defaults: { format: 'json' }
  end
  scope :song , controller: :song do
    post :surl, action: :song_url, defaults: { format: 'json' }
  end

  scope :sec, controller: :security do
    post :auth
    get  :login
    get  :signup
    get  :logout
    get  :login2
    post :log_js_error
    get  :timeout
    post :change_pw_save
    get  :expired
    get  :forgot_pw
    post :forgot_pw
    post :forgot_reset
    scope :pw_init do
      get ':person/:key', action: :pw_init
    end
  end

  scope :sec, controller: :registrations do
    get :complete_profile, action: :completed
    post :signup, action: :create
    put  :signup, action: :update
    post :change_pw, action: :update_pw
    put :update_profile, action: :update_profile
    get  :change_pw
    get ':id/complete_profile', action: :complete_profile
  end
  scope :sec, controller: :omni_authications do
    get  :complete_signup
    post :create_artist_or_client
  end

  # The Able route
  get :d, controller: :default,action: :index
  namespace :api do
    #version of app
    namespace :v1 do
      resources :store, only: [] do
        collection do
          post :redeem
          post :create_qr
        end
      end

      resources :app_errors ,only: [:create]

      post :like,       action: :like    , controller:  :likes
      post :dislike,    action: :dislike , controller:  :likes

      resources :albums, only: [:index] do
        collection do
          post :show_al
        end
      end
      get :nearest_venues, controller: :venues
      get :all_events, controller: :venues
      get :all_nearest_events, controller: :venues
      resources :venues, only: [:index]
      post :send_error,controller: :error_handling, action: :send_error
      # registerations
      resources :registrations, only: [:create]  do
        collection do
          post :valid_email
        end
      end
      #sessions
      resources :sessions, only: [:create] do
        collection do
          post :fb_auth_token, action: :fb_auth_token
          post :logout, action: :destroy
        end
      end
      #api controller for streaming
      scope :st, controller: :stream do
        get :co, action: :convert_one, defaults: { format: 'json' }
        get 'sos/:sid', action: :stream_one_song
      end
      #routes for songs
      post :search, controller: :search
      scope path: :search , controller: :search do
        post :genres
        post :suggested_playlists
      end
      # for discoveries
      resources :discover, only: [] do
        collection do
          post :all
        end
      end

      #routes for playlist
      scope controller: :playlist,path: :playlists, module: :playlist do
        post :all
        post :create
        post :add_song
        get ":playlist_id/songs",             action: :songs
        post :remove_song
      end

      scope controller: :song,path: :song, module: :playlist do
        get 'show/:sid',                      action: :show
        get 'recent_played',                  action: :recent_played
        get 'most_played',                    action: :most_played
        post :like
        post :create
        post :dislike
        post :like_or_dislike
      end
      #routes for artists
      #
      scope controller: :artists  ,path: :artist, module: :artist do
        post :all
        post :list
        post :profile
      end
    end
  end
  constraints :subdomain => "api" do
    resources :your_resources_go_here, :defaults => { :format => :json }, controller: 'admin'
  end
  get "/500", :to => "defect#internal_server_defect"
  get "/404", :to => "defect#routing_defect"
  get '*not_found', to: 'defect#routing_defect'
end
