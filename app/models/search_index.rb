class SearchIndex < ApplicationRecord

  belongs_to    :artist, inverse_of: :search_index, class_name: "Person::Artist", required: false
  belongs_to    :album,  inverse_of: :search_index, class_name: "Album::Album", required: false
  belongs_to    :song,  inverse_of: :search_index, class_name: "Song::Song", required: false

  def self.search(term)
  	where("s LIKE ? OR l LIKE ?", "%#{term}%", "%#{term}%")
  end
end
