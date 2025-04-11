# frozen_string_literal: true

class OtpController < ApplicationController
  before_action :require_staff_id, only: [:new, :create]

  def new
    @staff = Staff.find(session[:staff_id_for_otp])
  end

  def create
    @staff = Staff.find(session[:staff_id_for_otp])
    if @staff.valid_otp?(params[:otp])
      handle_remember_device(@staff) if params[:remember_device] == "1"
      session[:otp_verified] = true
      @staff.clear_otp
      redirect_to new_staff_session_path, notice: "OTP verified, signing in..."
    else
      flash.now[:alert] = "Invalid or expired OTP."
      render :new, status: :unprocessable_entity
    end
  end

  def resend
    staff = Staff.find_by(id: session[:staff_id_for_otp])
    if staff
      staff.generate_otp
      redirect_to new_otp_path, notice: "A new OTP has been sent."
    else
      redirect_to new_staff_session_path, alert: "Please sign in first."
    end
  end

  private

  def require_staff_id
    unless session[:staff_id_for_otp]
      redirect_to new_staff_session_path, alert: "Please sign in first."
    end
  end

  def handle_remember_device(staff)
    token = SecureRandom.urlsafe_base64(32)
    staff.update(mfa_remember_token: Digest::SHA256.hexdigest(token))
    cookies.signed[:mfa_remember] = {
      value: { staff_id: staff.id, token: token },
      expires: 30.days.from_now,
      httponly: true,
      secure: Rails.env.production?
    }
  end
end
