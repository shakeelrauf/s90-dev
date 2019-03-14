class SongCompilations < ActiveRecord::Migration[5.0]
  def change
    create_table :song_compilations do |t|
      t.string :title
      t.string :image_url
      t.timestamps
    end

    create_table :song_compilation_songs do |t|
      t.belongs_to :song, index: true
      t.belongs_to :song_compilation, index: true
      t.timestamps
    end
  end
end
