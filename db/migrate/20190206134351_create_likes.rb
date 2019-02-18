class CreateLikes < ActiveRecord::Migration[5.0]
  def up
    create_table :likes do |t|
      t.integer :likeable_id
      t.string :likeable_type
      t.integer :user_id

      t.timestamps
    end
    drop_table :likings
  end

  def down
    create_table :likings do |t|
      t.integer :liked_by_id
      t.integer :oid
      t.integer :artist_id
      t.string :ot

      t.timestamps
    end
    drop_table :likes
  end
end
