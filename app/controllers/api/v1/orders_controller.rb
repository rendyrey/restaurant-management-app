class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_staff!

  def index
    orders = Order.all.page(params[:page] || 1).per(20)
    orders = orders.by_status(params[:status]).page(params[:page] || 1).per(20) if params[:status].present?
    paginated_orders = orders.page(params[:page]).per(20) # 20 orders per page
    render json: {
      orders: paginated_orders.as_json(include: :customer),
      total_pages: paginated_orders.total_pages,
      current_page: paginated_orders.current_page,
      next_page: paginated_orders.next_page,
      prev_page: paginated_orders.prev_page
    }, status: :ok
  end
end
