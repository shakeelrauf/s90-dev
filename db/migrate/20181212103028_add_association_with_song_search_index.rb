class AddAssociationWithSongSearchIndex < ActiveRecord::Migration[5.0]
  def change
  	add_reference :search_indices, :song
  end
end
