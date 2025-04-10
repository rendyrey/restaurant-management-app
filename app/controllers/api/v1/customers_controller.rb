# frozen_string_literal: true

class Api::V1::CustomersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :validate_file!, only: :upload_csv

  def frequent_customers
    customers = Customer.loyal_customers.includes(:orders)
    render json: customers.as_json(include: :orders), status: :ok
  end

  def upload_csv
    tempfile = save_uploaded_file(params[:file])

    ProcessCustomerCsvJob.perform_later(tempfile.to_s)

    render json: { message: "CSV upload initiated." }, status: :accepted
  end

  private

  def validate_file!
    if params[:file].blank?
      render json: { error: "File is required." }, status: :bad_request
    elsif !params[:file].content_type.in?(%w[text/csv application/vnd.ms-excel])
      render json: { error: "Invalid file type. Only CSV allowed." }, status: :unsupported_media_type
    elsif params[:file].size > 5.megabytes
      render json: { error: "File too large. Max 5MB allowed." }, status: :payload_too_large
    end
  end

  def save_uploaded_file(file)
    tmp_path = Rails.root.join("tmp", "upload_#{SecureRandom.uuid}.csv")
    File.open(tmp_path, "wb") { |f| f.write(file.read) }
    tmp_path
  end
end
