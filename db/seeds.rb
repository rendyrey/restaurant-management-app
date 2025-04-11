# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "faker"

10.times do
  Customer.create!(name: Faker::Name.name, email: Faker::Internet.email, phone: Faker::PhoneNumber.phone_number, gender: ["male", "female"].sample)
end
50.times do
  Order.create!(customer: Customer.all.sample, order_date: Faker::Date.between(from: 35.days.ago, to: Date.today), status: ["pending", "completed", "cancelled"].sample)
end

(1..15).each do |i|
  Reservation.create!(customer: Customer.all.sample, table_number: i, reserved_at: Faker::Time.between(from: 2.hours.from_now, to: 24.hours.from_now), status: ["pending", "confirmed", "cancelled"].sample)
end
