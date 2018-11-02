class CreateSearchIndex < ActiveRecord::Migration[5.0]
  def change
    create_table :search_indices do |t|
      t.integer :r
      t.string :l
      t.string :s
      t.text :a
      t.references :album, foreign_key: true
      t.timestamps
    end
  end
end
