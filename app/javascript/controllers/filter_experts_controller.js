import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form"]; // Target the form element

  connect() {
    console.log("FilterExpertsController connected");
  }

  toggleFilter(event) {
    const filterOption = event.currentTarget;
    const filterType = filterOption.dataset.filter;
    const filterValue = filterOption.dataset.value;

    // Toggle the selected state
    filterOption.classList.toggle("selected");

    // Find or create a hidden input for the filter
    const inputName = `filters[${filterType}][]`;
    let existingInput = [...this.formTarget.elements].find(
      input => input.name === inputName && input.value === filterValue
    );

    if (filterOption.classList.contains("selected")) {
      // Add a hidden input if selected
      if (!existingInput) {
        const input = document.createElement("input");
        input.type = "hidden";
        input.name = inputName;
        input.value = filterValue;
        this.formTarget.appendChild(input);
      }
    } else {
      // Remove the hidden input if deselected
      if (existingInput) {
        existingInput.remove();
      }
    }
  }

  clearFilters() {
    // Reset all filter options
    this.formTarget.querySelectorAll(".filter-option").forEach(option => {
      option.classList.remove("selected");
    });

    // Remove all hidden inputs
    [...this.formTarget.elements].forEach(input => {
      if (input.type === "hidden" && input.name.startsWith("filters[")) {
        input.remove();
      }
    });

    // Submit the form to clear filters
    this.formTarget.requestSubmit();
  }

}
