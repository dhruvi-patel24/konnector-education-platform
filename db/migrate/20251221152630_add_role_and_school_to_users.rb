class AddRoleAndSchoolToUsers < ActiveRecord::Migration[8.2]
  def change
    add_column :users, :role, :integer
    add_reference :users, :school, null: false, foreign_key: true
  end
end
