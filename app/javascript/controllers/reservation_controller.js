// app/javascript/controllers/reservation_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "submit", "message"];

  connect() {
    console.log("Reservation controller connected");
  }

  bookTable(event) {
    event.preventDefault();
    const formData = new FormData(this.formTarget);
    this.submitTarget.disabled = true;
    this.submitTarget.textContent = "Booking...";

    fetch(this.formTarget.action, {
      method: "POST",
      body: formData,
      headers: {
        Accept: "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
    })
      .then((response) => {
        if (!response.ok) {
          return response.json().then((data) => {
            throw new Error(data.error || "Booking failed");
          });
        }
        return response.json();
      })
      .then((data) => this.showSuccess(data.message))
      .catch((error) => this.showError(error.message))
      .finally(() => {
        this.submitTarget.disabled = false;
        this.submitTarget.textContent = "Book Table";
      });
  }

  showSuccess(message) {
    this.messageTarget.innerHTML = `<div class="p-4 bg-green-100 border-l-4 border-green-500 text-green-700 rounded-md">${message}</div>`;
    this.messageTarget.classList.remove("hidden");
    this.formTarget.reset();
    setTimeout(() => this.hideMessage(), 5000); // Hide after 5s
  }

  showError(message) {
    this.messageTarget.innerHTML = `<div class="p-4 bg-red-100 border-l-4 border-red-500 text-red-700 rounded-md">${message}</div>`;
    this.messageTarget.classList.remove("hidden");
    setTimeout(() => this.hideMessage(), 5000);
  }

  hideMessage() {
    this.messageTarget.classList.add("hidden");
  }
}
