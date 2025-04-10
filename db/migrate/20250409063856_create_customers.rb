# frozen_string_literal: true

class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email, index: { unique: true }
      t.string :phone, index: { unique: true }
      t.string :gender
      t.timestamps
    end
  end
end
