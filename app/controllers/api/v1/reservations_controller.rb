# frozen_string_literal: true

class Api::V1::ReservationsController < ApplicationController
  def book_table
    begin
      reservation = Reservation.create!(reservation_params)

      render json: { message: "Reservation created.", reservation: reservation }, status: :created
    rescue => e
      render json: { error: e.message }, status: :bad_request
    end
  end

  def confirmed_reservations
    reservations = Reservation.confirmed_reservations_for_today

    render json: reservations.as_json(include: :customer), status: :ok
  end

  private

  def reservation_params
    params.permit(:customer_id, :table_number, :reserved_at, :status)
  end
end
