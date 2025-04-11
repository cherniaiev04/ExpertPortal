// app/javascript/controllers/toggle_visibility_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["checkbox", "container"];

  connect() {
    console.log("ToggleVisibilityController connected!");
    this.toggle(); // Initialize visibility based on the checkbox state when the controller connects
  }

  toggle() {
    if (this.checkboxTarget.checked) {
      this.containerTarget.classList.remove("d-none");
      this.containerTarget.classList.add("d-block");
      this.containerTarget.setAttribute("aria-hidden", "false");
      this.containerTarget.querySelector("input").focus(); // Optional: Focus the input field
    } else {
      this.containerTarget.classList.remove("d-block");
      this.containerTarget.classList.add("d-none");
      this.containerTarget.setAttribute("aria-hidden", "true");
    }
  }
}
