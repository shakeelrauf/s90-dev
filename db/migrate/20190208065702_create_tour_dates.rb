class CreateTourDates < ActiveRecord::Migration[5.0]
  def change
    create_table :artist_tour_dates do |t|
      t.date :date
      t.timestamp :door_time
      t.timestamp :show_time
      t.float :ticket_price
      t.references :venue, foreign_key: true, null: true

      t.timestamps
    end
  end
end
