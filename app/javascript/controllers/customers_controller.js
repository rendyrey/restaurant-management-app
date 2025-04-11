// app/javascript/controllers/frequent_customers_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["list", "customerList"];

  connect() {
    console.log("Frequent Customers controller connected");
  }

  fetchCustomers(event) {
    event.preventDefault();
    fetch("/api/v1/customers/frequent", {
      headers: {
        "Accept": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
    })
      .then((response) => {
        if (!response.ok) throw new Error("Network response was not ok");
        return response.json();
      })
      .then((data) => this.renderCustomers(data))
      .catch((error) => {
        console.error("Error fetching frequent customers:", error);
        this.customerListTarget.innerHTML = "<li class='text-red-600'>Failed to load customers.</li>";
      })
      .finally(() => {
        this.listTarget.classList.remove("hidden");
      });
  }

  renderCustomers(customers) {
    this.customerListTarget.innerHTML = "";
    if (customers.length === 0) {
      this.customerListTarget.innerHTML = "<li class='text-gray-600'>No frequent customers found.</li>";
      return;
    }
    customers.forEach((customer) => {
      const li = document.createElement("li");
      li.className = "text-gray-700";
      li.textContent = `${customer.name || customer.email} - ${customer.recent_orders.length} orders`;
      this.customerListTarget.appendChild(li);
    });
  }
}