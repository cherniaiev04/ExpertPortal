import { Controller } from "@hotwired/stimulus";
import { Modal } from "bootstrap";

export default class extends Controller {
  static targets = ["modal"];

  connect() {
    console.log("DeleteModal controller connected!");
    this.modal = new Modal(this.modalTarget);
  }

  showModal(event) {
    event.preventDefault();
    this.modal.show();
  }

  hideModal() {
    this.modal.hide();
  }
}
