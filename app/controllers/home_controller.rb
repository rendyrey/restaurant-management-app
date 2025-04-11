# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_staff!, only: %i[index]
  before_action :verify_otp!, only: %i[index]

  def index; end

  def reservations; end

  private

  def verify_otp!
    redirect_to new_otp_path, alert: "Please verify OTP." unless current_staff&.otp_verified?
  end
end
