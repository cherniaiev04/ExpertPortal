import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["select", "textInput", "container"];

  connect() {
    console.log("Tags controller connected!");
  }

  addFromSelect(event) {
    const selectedOption = this.selectTarget.selectedOptions[0];
    const selectedValue = selectedOption.value;
    const selectedName = selectedOption.text;

    if (selectedValue) {
      this.addTag(selectedValue, selectedName);
      this.selectTarget.selectedIndex = 0;
    }
  }

  addFromTextInput(event) {
    const inputValue = this.textInputTarget.value.trim();

    if (inputValue) {
      this.addTag(inputValue, inputValue);
      this.textInputTarget.value = "";
    }
  }

  addTag(id, name) {
    if (
      [...this.containerTarget.children].some(
        (tag) => tag.dataset.tagValue === id,
      )
    ) {
      return;
    }

    const fieldName = this.data.get("fieldName") || "tags[]";

    const tag = document.createElement("span");
    tag.classList.add("selected-tag");
    tag.style.backgroundColor = "#d40031";
    tag.style.color = "white";
    tag.style.borderRadius = "9999px";
    tag.style.padding = "0rem 0.5rem";
    tag.style.marginBottom = "0.25rem";
    tag.style.marginTop = "0.25rem";
    tag.style.marginRight = "0.5rem";
    tag.style.display = "inline-flex";
    tag.style.alignItems = "center";
    tag.dataset.tagValue = id;
    tag.innerHTML = `
      <span class="tag-text" style="margin-right: 0.5rem">${name}</span>
      <span style="margin-left: 0.5rem; cursor: pointer; font-weight: normal;" data-action="click->tags#remove">×</span>
      <input type="hidden" name="${fieldName}" value="${id}">
    `;

    this.containerTarget.appendChild(tag);
  }

  remove(event) {
    const tag = event.target.closest(".selected-tag");
    if (tag) {
      tag.remove();
    }
  }
}
