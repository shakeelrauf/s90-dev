Rails.application.routes.draw do
  root :to => "web#index"

  get 'home', to: 'home#index'

  # Artists
  get 'a', to: 'artist#index'
  post 'a/s', to: 'artist#search', defaults: { format: 'json' }
  post 'a/sp', to: 'artist#send_pic', defaults: { format: 'json' }
  post 'a/rp', to: 'artist#remove_pic', defaults: { format: 'json' }
  # Admin
  get 'ad', to: 'admin#artists'
  post 'ad/artist_new', to: 'admin#artist_new'
  post 'ad/artist_save', to: 'admin#artist_save', defaults: { format: 'json' }
  get 'ad/artists', to: 'admin#artists'
  get 'ad/artist/:action', to: 'admin#artist'     
  post 'ad/artist/:action', to: 'admin#artist'

  get 'al/cover/:pid/:alid', to: 'album#cover'
  get 'al/my/:pid', to: 'album#my'
  get 'al/s/:pid/:alid', to: 'album#songs'
  get 'album/:actp/:pid', to: 'album#index'
  post 'album/:actp/:pid', to: 'album#index'
  get 'auth/:provider/callback', to: 'omni_authications#callback'
  post 'auth/:provider/callback', to: 'omni_authications#callback'
  get 'auth/:provider/callback2', to: 'omni_authications#callback2'
  post 'auth/:provider/callback2', to: 'omni_authications#callback2'

  # Mobile...
  post 'al/sn', to: 'album#song_names', defaults: { format: 'json' }
  # match 'al/asn', to: 'album#album_song_names', defaults: { format: 'json' },   via: [:post]

 # match 'al/up', to: 'album#upload',                                            via: [:get]
  post 'al/send_cover', to: 'album#send_cover', defaults: { format: 'json' }
  post 'al/rem_cover', to: 'album#rem_cover', defaults: { format: 'json' }
  post 'al/send_songs', to: 'album#send_songs', defaults: { format: 'json' }
  # match 'al/sos', to: 'album#stream_one_song', defaults: { format: 'json' },    via: [:get]
  # match 'st/sos', to: 'stream#stream_one_song',                                 via: [:get]
  get 'st/co', to: 'stream#convert_one', defaults: { format: 'json' }

  post 'al/remove_song', to: 'album#remove_song', defaults: { format: 'json' }
  # match 'al/test_aws', to: 'album#test_aws', defaults: { format: 'json' },      via: [:get]

  get 'p/p', to: 'person#profile'
  get 'p/p/:pid', to: 'person#profile'

  # Mobile
  get 's/t', to: 'shared#token'
  post 'search/search', to: 'search#search', defaults: { format: 'json' }
  post 'song/surl', to: 'song#song_url', defaults: { format: 'json' }


  post 'sec/auth', to: 'security#auth'
  get 'sec/login', to: 'security#login'
  post 'sec/signup', to: 'registrations#create'
  get 'sec/signup', to: 'security#signup'
  get 'sec/logout', to: 'security#logout'
  get 'sec/timeout', to: 'security#timeout'
  get 'sec/login2', to: 'security#login2'
  post 'sec/log_js_error', to: 'security#log_js_error'
  post 'sec/change_pw_save', to: 'security#change_pw_save'
  get 'sec/expired', to: 'security#expired'
  get 'sec/forgot_pw', to: 'security#forgot_pw'
  post 'sec/forgot_pw', to: 'security#forgot_pw'
  get 'sec/pw_init/:person/:key', to: 'security#pw_init'
  get 'sec/complete_signup', to: 'omni_authications#complete_signup'
  post 'sec/create_artist_or_client', to: 'omni_authications#create_artist_or_client'
  
  post 'sec/forgot_reset', to: 'security#forgot_reset'

  # The Able route
  get 'd', to: 'default#index'


  namespace :api do
    namespace :v1 do
      resources :registrations, only: [:create]
      resources :sessions, only: [:create]
    end
  end
end
