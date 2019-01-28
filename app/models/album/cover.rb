class Album::Cover < ApplicationRecord
  belongs_to  :album, inverse_of: :cover, class_name: "Album::Album"
end
