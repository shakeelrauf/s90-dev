class AddColumnToSearchIndices < ActiveRecord::Migration[5.0]
  def change
    add_column :search_indices, :is_suspended, :boolean, default: false
  end
end
