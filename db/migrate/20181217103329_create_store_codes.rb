class CreateStoreCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :store_codes do |t|
      t.string :token
      t.string :image_name
      t.boolean :redeemed

      t.timestamps
    end
  end
end
