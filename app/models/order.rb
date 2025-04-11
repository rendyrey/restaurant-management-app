# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :customer

  scope :last_5_orders, -> { order(created_at: :desc).limit(5) }
  scope :last_30_days_orders, -> { where("created_at >= ?", 30.days.ago) }
end
