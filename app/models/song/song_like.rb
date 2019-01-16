class Song::SongLike < Liking
  belongs_to :song, class_name: 'Song::Song',inverse_of: :song_likes, foreign_key: 'oid'
  belongs_to :liked_by, class_name: 'Person::Person', inverse_of: :liked_bys, foreign_key: 'liked_by_id'
end