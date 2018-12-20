class AddIsSuspendedToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :is_suspended, :boolean, default: false
  end
end
