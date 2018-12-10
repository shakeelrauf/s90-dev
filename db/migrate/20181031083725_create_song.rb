class CreateSong < ActiveRecord::Migration[5.0]
  def change
    create_table :song_songs do |t|
      t.integer :order
      t.string :title
      t.string :ext
      t.string :ext_orig
      t.integer :published
      t.date :published_date
      t.integer :duration
      t.references :album, foreign_key: true
      t.timestamps
    end
  end
end
