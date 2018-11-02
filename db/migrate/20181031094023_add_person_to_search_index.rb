class AddPersonToSearchIndex < ActiveRecord::Migration[5.0]
  def change
    add_column :search_indices, :person_id, :integer
    add_column :search_indices, :manager_id, :integer
    add_column :search_indices, :artist_id, :integer
  end
end
