class MakeSchoolIdNullableInUsers < ActiveRecord::Migration[8.2]
  def change
    change_column_null :users, :school_id, true
  end
end
