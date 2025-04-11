import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "input", "label", "option"];

  connect() {
    console.log("ProjectFiltersController verbunden");
    this.updateLabels();
  }

  updateLabels() {
    this.labelTargets.forEach((label) => {
      const dropdown = label.closest(".dropdown");
      const options = dropdown.querySelectorAll("input[type='checkbox']");
      const selected = [...options]
        .filter((option) => option.checked)
        .map((option) => option.value);

      if (selected.length === 0) {
        label.textContent = "Wählen Sie eine Option";
      } else if (selected.includes("Select all")) {
        label.textContent = "Alle ausgewählt";
      } else {
        label.textContent = selected.join(", ");
      }
    });

    this.updateHiddenInputs();
  }

  toggleOption(event) {
    const option = event.currentTarget;

    if (option.value === "Select all") {
      this.optionTargets.forEach((opt) => {
        if (opt !== option) opt.checked = option.checked;
      });
    } else {
      const allOption = this.optionTargets.find((opt) => opt.value === "Select all");
      if (allOption) allOption.checked = false;
    }

    this.updateLabels();
  }

  updateHiddenInputs() {
    console.log("Aktualisiere versteckte Eingaben...");

    // Entfernen der bestehenden versteckten Eingaben
    const existingHiddenInputs = this.formTarget.querySelectorAll(
      "input[type='hidden'][name^='filters']"
    );
    existingHiddenInputs.forEach((input) => input.remove());

    // Hinzufügen neuer versteckter Eingaben für ausgewählte Optionen
    const dropdowns = this.formTarget.querySelectorAll(".dropdown-menu");
    dropdowns.forEach((dropdown) => {
      const filterName = dropdown.dataset.filterName;
      const selectedOptions = [...dropdown.querySelectorAll("input[type='checkbox']:checked")];

      console.log(`Ausgewählte Optionen für ${filterName}:`, selectedOptions);

      selectedOptions.forEach((option) => {
        if (option.value !== "Select all") {
          const hiddenInput = document.createElement("input");
          hiddenInput.type = "hidden";
          hiddenInput.name = `filters[${filterName}][]`;
          hiddenInput.value = option.value;

          console.log("Füge versteckte Eingabe hinzu:", hiddenInput);
          this.formTarget.appendChild(hiddenInput);
        }
      });
    });
  }

  clearAll() {
    this.optionTargets.forEach((option) => (option.checked = false));
    this.updateLabels();
    this.updateHiddenInputs();

    const input = this.inputTarget;
    input.value = '';

    this.formTarget.requestSubmit();
  }
}
