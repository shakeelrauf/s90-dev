class CreateLikings < ActiveRecord::Migration[5.0]
  def change
    create_table :likings do |t|
      t.integer :liked_by_id
      t.integer :oid
      t.integer :artist_id
      t.string :ot

      t.timestamps
    end
  end
end
