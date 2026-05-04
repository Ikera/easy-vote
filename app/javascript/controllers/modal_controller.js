import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "firstInput"]

  disconnect() {
    document.body.classList.remove("overflow-hidden")
  }

  open() {
    if (!this.hasPanelTarget) return

    document.body.classList.add("overflow-hidden")
    if (this.hasFirstInputTarget) this.firstInputTarget.focus()
  }

  close(event) {
    if (event) event.preventDefault()
    document.body.classList.remove("overflow-hidden")
    this.element.innerHTML = ""
  }

  closeOnBackdrop(event) {
    if (!this.hasPanelTarget) return
    if (!this.panelTarget.contains(event.target)) this.close()
  }

  closeOnEscape(event) {
    if (event.key === "Escape") this.close()
  }
}
