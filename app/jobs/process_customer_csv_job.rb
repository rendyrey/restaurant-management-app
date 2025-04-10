# frozen_string_literal: true

require "csv"

class ProcessCustomerCsvJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    CSV.foreach(file_path, headers: true).with_index(2) do |row, line_number|
      begin
        customer_params = row.to_hash.slice("name", "email", "phone", "gender")

        unless valid_customer?(customer_params)
          log_error("Invalid data at line #{line_number}: #{customer_params}")
          next
        end

        Customer.create!(customer_params)
      rescue => e
        log_error("Error processing line #{line_number}: #{e.message}")
      end
    end

    File.delete(file_path) if File.exist?(file_path)
  end

  private

  def valid_customer?(params)
    params["email"].present? &&
      params["email"] =~ URI::MailTo::EMAIL_REGEXP &&
      params["name"].present?
  end

  def log_error(message)
    Rails.logger.error("[Customer CSV Upload] #{message}")
    # Optionally persist to DB for admin review:
    # CsvUploadError.create!(message: message)
  end
end
