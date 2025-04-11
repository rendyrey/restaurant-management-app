// app/javascript/controllers/today_reservations_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["tableBody"];

  connect() {
    this.fetchReservations();
  }

  fetchReservations() {
    fetch("/api/v1/reservations/today", {
      headers: {
        "Accept": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
    })
      .then((response) => {
        if (!response.ok) throw new Error("Failed to fetch reservations");
        return response.json();
      })
      .then((data) => this.renderReservations(data))
      .catch((error) => {
        console.error("Error:", error);
        this.tableBodyTarget.innerHTML = `<tr><td colspan="5" class="text-red-600 p-4">Error loading reservations</td></tr>`;
      });
  }

  renderReservations(reservations) {
    this.tableBodyTarget.innerHTML = "";
    if (reservations.length === 0) {
      this.tableBodyTarget.innerHTML = `<tr><td colspan="5" class="text-gray-600 p-4">No reservations for today</td></tr>`;
      return;
    }
    reservations.forEach((reservation) => {
      const row = document.createElement("tr");
      row.className = "border-t border-gray-200";
      row.innerHTML = `
        <td class="p-4 text-gray-700">${reservation.id}</td>
        <td class="p-4 text-gray-700">${reservation.customer.name}</td>
        <td class="p-4 text-gray-700">${reservation.table_number}</td>
        <td class="p-4 text-gray-700">${new Date(reservation.reserved_at).toLocaleString()}</td>
        <td class="p-4 text-gray-700">${reservation.status}</td>
      `;
      this.tableBodyTarget.appendChild(row);
    });
  }
}