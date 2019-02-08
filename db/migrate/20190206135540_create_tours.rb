class CreateTours < ActiveRecord::Migration[5.0]
  def change
    create_table :artist_tours do |t|
      t.string :name
      t.timestamp :door_time
      t.timestamp :show_time
      t.float :ticket_price
      t.references :venue, foreign_key: true, null: true

      t.timestamps
    end
  end
end
