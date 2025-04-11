# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :customer

  scope :last_5_orders, -> { order(order_date: :desc).limit(5) }
  scope :last_30_days_orders, -> { where("order_date >= ?", 30.days.ago) }
end
