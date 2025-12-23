class CreateEnrollments < ActiveRecord::Migration[8.0]
  def change
    create_table :enrollments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :batch, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end

    add_index :enrollments, [ :user_id, :batch_id ], unique: true
  end
end
