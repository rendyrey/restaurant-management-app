// app/javascript/controllers/orders_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["tableBody", "filter", "pagination"];

  connect() {
    this.currentPage = 1;
    this.fetchOrders();
  }

  fetchOrders(page = this.currentPage) {
    const status = this.filterTarget.value;
    const url = `/api/v1/orders?page=${page}${status ? `&status=${status}` : ""}`;
    fetch(url, {
      headers: {
        "Accept": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
    })
      .then((response) => {
        if (!response.ok) throw new Error("Failed to fetch orders");
        return response.json();
      })
      .then((data) => {
        this.renderOrders(data.orders);
        this.renderPagination(data);
      })
      .catch((error) => {
        console.error("Error:", error);
        this.tableBodyTarget.innerHTML = `<tr><td colspan="4" class="text-red-600 p-4">Error loading orders</td></tr>`;
      });
  }

  filterOrders(event) {
    this.currentPage = 1; // Reset to first page on filter change
    this.fetchOrders();
  }

  changePage(event) {
    event.preventDefault();
    const page = event.target.dataset.page;
    if (page) {
      this.currentPage = parseInt(page);
      this.fetchOrders();
    }
  }

  renderOrders(orders) {
    this.tableBodyTarget.innerHTML = "";
    if (orders.length === 0) {
      this.tableBodyTarget.innerHTML = `<tr><td colspan="4" class="text-gray-600 p-4">No orders found</td></tr>`;
      return;
    }
    orders.forEach((order) => {
      const row = document.createElement("tr");
      row.className = "border-t border-gray-200";
      row.innerHTML = `
        <td class="p-4 text-gray-700">${order.id}</td>
        <td class="p-4 text-gray-700">${order.customer.name}</td>
        <td class="p-4 text-gray-700">${order.customer.email}</td>
        <td class="p-4 text-gray-700">${order.status}</td>
        <td class="p-4 text-gray-700">${new Date(order.created_at).toLocaleString()}</td>
      `;
      this.tableBodyTarget.appendChild(row);
    });
  }

  renderPagination(data) {
    const { current_page, total_pages, next_page, prev_page } = data;
    let html = '<div class="flex justify-center gap-2 mt-4">';
    
    // Previous Button
    html += prev_page
      ? `<a href="#" data-page="${prev_page}" data-action="click->orders#changePage" class="px-3 py-1 bg-indigo-600 text-white rounded-md hover:bg-indigo-700">Prev</a>`
      : `<span class="px-3 py-1 bg-gray-300 text-gray-500 rounded-md cursor-not-allowed">Prev</span>`;

    // Page Numbers (simple version: show current and total)
    html += `<span class="px-3 py-1 text-gray-700">Page ${current_page} of ${total_pages}</span>`;

    // Next Button
    html += next_page
      ? `<a href="#" data-page="${next_page}" data-action="click->orders#changePage" class="px-3 py-1 bg-indigo-600 text-white rounded-md hover:bg-indigo-700">Next</a>`
      : `<span class="px-3 py-1 bg-gray-300 text-gray-500 rounded-md cursor-not-allowed">Next</span>`;

    html += '</div>';
    this.paginationTarget.innerHTML = html;
  }
}