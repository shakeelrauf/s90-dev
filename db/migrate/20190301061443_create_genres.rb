class CreateGenres < ActiveRecord::Migration[5.0]
  def change
    create_table :genres do |t|
      t.string :name

      t.timestamps
    end

    create_table :release_genres do |t|
      t.belongs_to :genre, index: true
      t.belongs_to :album, index: true
      t.timestamps
    end
  end
end
