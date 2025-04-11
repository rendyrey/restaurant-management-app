# frozen_string_literal: true

class Reservation < ApplicationRecord
  RESERVATION_DURATION = 1.hour

  belongs_to :customer

  enum :status, { pending: "pending", confirmed: "confirmed", cancelled: "cancelled" }, default: :pending

  default_scope { includes(:customer) }

  scope :confirmed_reservations_for_today, -> { where(status: "confirmed").where(reserved_at: Time.current.beginning_of_day..Time.current.end_of_day) }

  # validations
  validates :table_number, presence: true
  validates :reserved_at, presence: true
  validate :no_double_booking, on: :create
  validate :reservation_in_future

  # Custom validation to prevent double-booking
  def no_double_booking
    # Assume a reservation lasts 2 hours; adjust as needed
    reservation_duration = RESERVATION_DURATION
    start_time = reserved_at - reservation_duration
    end_time = reserved_at + reservation_duration

    # Check for overlapping confirmed reservations
    overlapping_reservations = Reservation.where(table_number: table_number)
      .where(status: "confirmed")
      .where("reserved_at <= ? AND reserved_at > ?",
             end_time, start_time)

    if overlapping_reservations.exists?
      errors.add(:reserved_at, "This table is already reserved for the selected time.")
    end
  end

  # Custom validation to ensure reservation is at least 1 hour in the future
  def reservation_in_future
    return unless reserved_at

    if reserved_at < Time.current + 1.hour
      errors.add(:reserved_at, "Reservation must be at least 1 hour in the future.")
    end
  end
end
