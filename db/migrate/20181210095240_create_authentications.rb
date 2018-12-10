class CreateAuthentications < ActiveRecord::Migration[5.0]
  def change
    create_table :authentications do |t|
      t.string :authentication_token
      t.references :person
      t.timestamps
    end
  end
end
