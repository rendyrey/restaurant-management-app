# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :customer
  enum :status, { pending: "pending", preparing: "preparing", ready: "ready", delivered: "delivered" }, default: :pending

  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :last_5_orders, -> { order(order_date: :desc).limit(5) }
  scope :last_30_days_orders, -> { where("order_date >= ?", 30.days.ago) }
end
