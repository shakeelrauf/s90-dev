Rails.application.routes.draw do
  root :to => "web#index"

  get 'home' => 'home#index'

  # Artists
  get :a , action: :index, controller: :artist
  scope  :a , controller: :artist do
    post :s , action: :search, defaults: { format: 'json' }
    post :sp , action: :send_pic, defaults: { format: 'json' }
    post :rp , action: :remove_pic, defaults: { format: 'json' }
  end
  # Admin
  get :ad ,action: :artists, controller: :admin
  scope  :ad , controller: :admin do
    post :artist_new 
    get  :artist_new 
    post :artist_save , defaults: { format: 'json' }
    get  :artists 
    get  :all
    scope :artist do
      get  ':action', action: :artist
      post ':action', action: :artist
    end
  end
  # Album

  scope :al , controller: :album do
    post :sn, action: :song_names, defaults: { format: 'json' }
    post :send_cover,  defaults: { format: 'json' }
    post :rem_cover,   defaults: { format: 'json' }
    post :send_songs,  defaults: { format: 'json' }
    post :remove_song, defaults: { format: 'json' }
    scope :cover do
      get ':pid/:alid', action: :cover
    end
    scope :my do
      get ':pid', action: :my
    end
    scope :s do
      get ':pid/:alid', action: :songs
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
  end
  scope :p, controller: :person do
    get :p , action: :profile
    scope :p do
      get ':pid', action: :profile
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
    namespace :v1 do
      resources :registrations, only: [:create]  do
        collection do
          post :valid_email
        end
      end
      resources :sessions, only: [:create] do
        collection do
          post :logout, action: :destroy
        end
      end
    end
  end
end
