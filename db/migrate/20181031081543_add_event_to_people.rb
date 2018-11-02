class AddEventToPeople < ActiveRecord::Migration[5.0]
  def change
    add_reference :people, :event, foreign_key: true
  end
end
