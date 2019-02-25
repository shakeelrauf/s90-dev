class RemoveEventFromPeople < ActiveRecord::Migration[5.0]
  def change
    remove_reference :people, :event, foreign_key: true
  end
end
