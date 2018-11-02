class CreateCover < ActiveRecord::Migration[5.0]
  def change
    create_table :covers do |t|
      t.string :link
      t.references :album, foreign_key: true
      t.timestamps
    end
  end
end
