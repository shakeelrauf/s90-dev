Rails.application.routes.draw do
  root :to => "web#index"

  match 'home', to: 'home#index',                                               via: [:get]
  match 'home/frames', to: 'home#frames',                                       via: [:get]

  # Artists
  match 'a', to: 'artist#index',                                                via: [:get]
  match 'a/s', to: 'artist#search', defaults: { format: 'json' },               via: [:post]
  match 'a/sp', to: 'artist#send_pic', defaults: { format: 'json' },            via: [:post]
  match 'a/rp', to: 'artist#remove_pic', defaults: { format: 'json' },          via: [:post]

  # Admin
  match 'ad', to: 'admin#artists',                                              via: [:get]
  match 'ad/artist_new', to: 'admin#artist_new',                                via: [:get]
  match 'ad/artist_save', to: 'admin#artist_save', defaults: { format: 'json' },     via: [:post]
  match 'ad/artists', to: 'admin#artists',                                      via: [:get]
  match 'ad/artist/:action', to: 'admin#artist',                                via: [:get, :post]

  match 'al/cover/:pid/:alid', to: 'album#cover',                               via: [:get]
  match 'al/my/:pid', to: 'album#my',                                           via: [:get]
  match 'al/s/:pid/:alid', to: 'album#songs',                                   via: [:get]

  match 'album/:actp/:pid', to: 'album#index',                                  via: [:get, :post]

  # Mobile...
  match 'al/sn', to: 'album#song_names', defaults: { format: 'json' },          via: [:post]
  # match 'al/asn', to: 'album#album_song_names', defaults: { format: 'json' },   via: [:post]

 # match 'al/up', to: 'album#upload',                                            via: [:get]
  match 'al/send_cover', to: 'album#send_cover', defaults: { format: 'json' },  via: [:post]
  match 'al/rem_cover', to: 'album#rem_cover', defaults: { format: 'json' },    via: [:post]
  match 'al/send_songs', to: 'album#send_songs', defaults: { format: 'json' },  via: [:post]
  # match 'al/sos', to: 'album#stream_one_song', defaults: { format: 'json' },    via: [:get]
  # match 'st/sos', to: 'stream#stream_one_song',                                 via: [:get]
  match 'st/co', to: 'stream#convert_one', defaults: { format: 'json' },        via: [:get]

  match 'al/remove_song', to: 'album#remove_song', defaults: { format: 'json' },via: [:post]
  # match 'al/test_aws', to: 'album#test_aws', defaults: { format: 'json' },      via: [:get]

  match 'p/p', to: 'person#profile',                                            via: [:get]
  match 'p/p/:pid', to: 'person#profile',                                       via: [:get]

  # Mobile
  match 's/t', to: 'shared#token',                                              via: [:get]
  match 'search/search', to: 'search#search', defaults: { format: 'json' },     via: [:post]
  match 'song/surl', to: 'song#song_url', defaults: { format: 'json' },         via: [:post]


  match 'sec/auth', to: 'security#auth', defaults: { format: 'json' },          via: [:post]
  match 'sec/login', to: 'security#login',                                      via: [:get]
  match 'sec/logout', to: 'security#logout',                                    via: [:get]
  match 'sec/timeout', to: 'security#timeout',                                  via: [:get]
  match 'sec/login2', to: 'security#login2',                                    via: [:get]
  match 'sec/log_js_error', to: 'security#log_js_error',                        via: [:post]

  # The Able route
  match 'd', to: 'default#index',                                               via: [:get]

end
