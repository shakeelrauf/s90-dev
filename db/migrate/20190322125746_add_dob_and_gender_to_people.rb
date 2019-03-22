class AddDobAndGenderToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :dob, :date
    add_column :people, :gender, :string
  end
end
