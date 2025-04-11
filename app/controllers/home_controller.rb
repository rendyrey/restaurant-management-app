class HomeController < ApplicationController
  before_action :authenticate_staff!
  before_action :verify_otp!

  def index

  end

  def coba

  end

  private

  def verify_otp!
    redirect_to new_otp_path, alert: "Please verify OTP." unless current_staff&.otp_verified?
  end
end
