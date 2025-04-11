# frozen_string_literal: true

class StaffMailer < ApplicationMailer
  def otp_email(staff)
    @staff = staff
    mail(to: @staff.email, subject: "OTP for login")
  end
end
