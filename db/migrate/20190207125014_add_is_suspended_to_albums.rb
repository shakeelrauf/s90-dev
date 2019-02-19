class AddIsSuspendedToAlbums < ActiveRecord::Migration[5.0]
  def change
    add_column :albums, :is_suspended, :boolean, default: false
  end
end
