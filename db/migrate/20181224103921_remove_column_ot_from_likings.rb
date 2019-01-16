class RemoveColumnOtFromLikings < ActiveRecord::Migration[5.0]
  def change
    remove_column :likings, :ot, :string
    add_column :likings, :type, :string
  end
end
