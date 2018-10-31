class CreatePersonConfig < ActiveRecord::Migration[5.0]
  def change
    create_table :person_configs do |t|
      t.boolean :has_tracker_profile
      t.string :pw_reinit_key
      t.datetime :pw_reinit_exp
      t.integer :failed_auth_count
      t.time :lock_until
      t.string :lock_cause
      t.integer :lock_count
      t.references :person, foreign_key: true
      t.timestamps
    end
  end
end
