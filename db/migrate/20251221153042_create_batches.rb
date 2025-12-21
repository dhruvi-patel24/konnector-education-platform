class CreateBatches < ActiveRecord::Migration[8.2]
  def change
    create_table :batches do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
