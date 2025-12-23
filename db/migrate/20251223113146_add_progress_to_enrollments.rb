class AddProgressToEnrollments < ActiveRecord::Migration[8.0]
  def change
    add_column :enrollments, :progress, :integer, default: 0
  end
end
