# frozen_string_literal: true

class Customer < ApplicationRecord
  has_many :orders

  scope :loyal_customers, -> { joins(:orders).where("orders.order_date > ?", 30.days.ago).group("customers.id").having("COUNT(orders.id) >= ?", 5) }

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
end
