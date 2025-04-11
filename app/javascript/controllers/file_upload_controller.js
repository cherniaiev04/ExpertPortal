import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container", "fileInput"];

  connect() {
    this.dataTransfer = new DataTransfer();
    console.log("File Upload Controller connected");
  }

  addFile(event) {
    const input = event.target;
    const container = this.containerTarget;
    const files = Array.from(input.files);

    const isMultiple = input.hasAttribute("multiple");

    if (isMultiple) {
      files.forEach((file) => {
        this.dataTransfer.items.add(file);
        const fileTag = this.createNewFileTag(file);
        container.insertAdjacentHTML("beforeend", fileTag);
      });

      input.files = this.dataTransfer.files;
    } else {
      const file = files[0];
      if (file) {
        container.innerHTML = "";
        const fileTag = this.createNewFileTag(file);
        container.insertAdjacentHTML("beforeend", fileTag);
      }
    }
  }

  remove(event) {
    const tag = event.currentTarget.closest(".selected-tag");
    if (!tag) return;

    const fileName = tag.getAttribute("data-file-name");
    const fileType = tag.getAttribute("data-file-type");
    const fileCategory = tag.getAttribute("data-file-category");

    if (fileType === "new") {
      if (fileCategory === "certificates") {
        this.removeFromDataTransfer(fileName);
        const input = this.fileInputTarget;
        input.files = this.dataTransfer.files;
      } else if (fileCategory === "cv") {
        const input = this.fileInputTarget;
        input.value = "";
      }
      tag.remove();
    } else if (fileType === "existing") {
      if (fileCategory === "cv") {
        const removeInput = document.createElement("input");
        removeInput.type = "hidden";
        removeInput.name = "expert[cv_to_remove]";
        removeInput.value = "true";
        this.element.closest("form").appendChild(removeInput);
        tag.remove();
      } else if (fileCategory === "certificates") {
        const fileId = tag.getAttribute("data-file-id");
        if (fileId) {
          const removeInput = document.createElement("input");
          removeInput.type = "hidden";
          removeInput.name = "expert[certificates_to_remove][]";
          removeInput.value = fileId;
          this.element.closest("form").appendChild(removeInput);
          tag.remove();
        }
      }
    }
  }

  createNewFileTag(file) {
    const category = this.fileCategory();
    return `
      <span
        class="selected-tag"
        style="background-color:#d40031; color:white; border-radius:9999px; padding:0rem 0.5rem; margin-top:0.25rem; margin-bottom:0.25rem; display:inline-flex; align-items:center;"
        data-file-type="new" data-file-category="${category}" data-file-name="${file.name}">
        ${file.name}
        <span
          style="margin-left:0.5rem; cursor:pointer; font-weight:normal;"
          data-action="click->file-upload#remove">×</span>
      </span>
    `;
  }

  fileCategory() {
    const input = this.fileInputTarget;
    if (input.name.includes("cv")) {
      return "cv";
    } else if (input.name.includes("certificates")) {
      return "certificates";
    }
    return "";
  }

  removeFromDataTransfer(fileName) {
    const files = Array.from(this.dataTransfer.files);
    this.dataTransfer.clear();
    files.forEach((file) => {
      if (file.name !== fileName) {
        this.dataTransfer.items.add(file);
      }
    });
  }
}
