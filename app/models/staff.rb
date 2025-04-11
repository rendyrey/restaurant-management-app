# frozen_string_literal: true

class Staff < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  def generate_otp
    self.otp_secret = SecureRandom.hex(3) # Generates a 6-character OTP
    self.otp_token = Digest::SHA256.hexdigest(otp_secret)
    self.otp_token_expires_at = 15.minutes.from_now
    save!
    StaffMailer.otp_email(self).deliver_now
  end

  def valid_otp?(otp)
    return false if otp_token.nil? || otp_token_expires_at.nil? || otp_token_expires_at < Time.current

    Digest::SHA256.hexdigest(otp) == otp_token
  end

  def clear_otp
    self.otp_secret = nil
    self.otp_token = nil
    self.otp_token_expires_at = nil
    save!
  end

  def otp_verified?
    otp_token.nil? && otp_token_expires_at.nil?
  end
end
