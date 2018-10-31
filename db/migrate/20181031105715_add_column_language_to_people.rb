class AddColumnLanguageToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :language, :string, default: 'fr'
  end
end
