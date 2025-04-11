# frozen_string_literal: true

class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :table_number
      t.datetime :reserved_at
      t.string :status
      t.timestamps
    end

    add_index :reservations, :reserved_at
    add_index :reservations, [:customer_id, :reserved_at], unique: true
  end
end
