class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :uid
      t.string :manager_id
      t.string :provider
      t.string :email
      t.string :pw
      t.string :oauth_token
      t.string :salt
      t.boolean :force_new_pw, default: false
      t.string :locale, default: 'fr'
      t.string :authentication_token
      t.string :profile_pic_name
      t.boolean :profile_complete_signup, :default => false
      t.text :roles
      t.text :tags
      t.timestamps
    end
  end
end
