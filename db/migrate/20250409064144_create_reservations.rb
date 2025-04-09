class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :table_number
      t.datetime :reserved_at
      t.string :status
      t.timestamps
    end
  end
end
