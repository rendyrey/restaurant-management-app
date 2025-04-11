# frozen_string_literal: true

class Staffs::SessionsController < Devise::SessionsController
  before_action :check_otp, only: [:create]
  before_action :check_remembered_device, only: [:create]

  def new
    super
  end

  def create
    self.resource = warden.authenticate(auth_options)
    if resource
      if session[:otp_verified]
        complete_sign_in(resource)
      else
        resource.generate_otp
        session[:staff_id_for_otp] = resource.id
        redirect_to new_otp_path
      end
    else
      super
    end
  end

  def destroy
    current_staff.update(mfa_remember_token: nil) if current_staff
    cookies.delete(:mfa_remember)
    super
  end

  private

  def check_otp
    if session[:otp_verified]
      session.delete(:otp_verified)
    end
  end

  def check_remembered_device
    cookie = cookies.signed[:mfa_remember]
    return unless cookie

    staff_id = cookie[:staff_id]
    token = cookie[:token]
    staff = Staff.find_by(id: staff_id)
    @remembered_device = staff && staff.mfa_remember_token == Digest::SHA256.hexdigest(token)
  end

  def complete_sign_in(resource)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    session.delete(:staff_id_for_otp)
    respond_with resource, location: after_sign_in_path_for(resource)
  end
end
