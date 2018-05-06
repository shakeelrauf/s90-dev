Rails.application.routes.draw do
  match 'a', to: 'artist#index',                                                via: [:get]
  match 'a/s', to: 'artist#search', defaults: { format: 'json' },               via: [:post]

  match 'al/up', to: 'album#upload',                                            via: [:get]
  match 'al/send_cover', to: 'album#send_cover', defaults: { format: 'json' },  via: [:post]

  match 's/t', to: 'shared#token',                                              via: [:get]

  match 'sec/login', to: 'security#login',                                      via: [:get]
  match 'sec/login2', to: 'security#login2',                                    via: [:get]
end
