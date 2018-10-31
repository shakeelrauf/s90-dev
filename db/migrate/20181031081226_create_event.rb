class CreateEvent < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :key
      t.string :val
      t.timestamps
    end
  end
end
