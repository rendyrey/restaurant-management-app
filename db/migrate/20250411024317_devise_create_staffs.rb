# frozen_string_literal: true

class DeviseCreateStaffs < ActiveRecord::Migration[8.0]
  def change
    create_table :staffs do |t|
      ## Database authenticatable
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      ## MFA fields
      t.string :otp_secret
      t.string :otp_token
      t.datetime :otp_token_expires_at
      t.string :mfa_remember_token

      t.timestamps null: false
    end

    add_index :staffs, :email, unique: true
    add_index :staffs, :reset_password_token, unique: true
    # add_index :staffs, :confirmation_token,   unique: true
    # add_index :staffs, :unlock_token,         unique: true
  end
end
