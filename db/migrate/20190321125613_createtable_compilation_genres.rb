class CreatetableCompilationGenres < ActiveRecord::Migration[5.0]
  def change
  	create_table :compilation_genres do |t|
      t.belongs_to :genre, index: true
      t.belongs_to :compilation, index: true
      t.timestamps
    end
  end
end
