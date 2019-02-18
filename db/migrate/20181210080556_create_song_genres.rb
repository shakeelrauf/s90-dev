class CreateSongGenres < ActiveRecord::Migration[5.0]
  def change
    create_table :song_genres do |t|
      t.string :name

      t.timestamps
    end

    Song::Genre::NAMES_OF_GENRE.each do |name|
    	genre = Song::Genre.new(name: name)
    	genre.save!
    end
  end
end
