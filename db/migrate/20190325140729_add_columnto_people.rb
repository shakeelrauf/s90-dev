class AddColumntoPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :address, :string
  end
end
