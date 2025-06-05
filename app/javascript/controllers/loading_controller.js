import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["spinner", "forecast"]

  connect() {
    document.addEventListener("turbo:before-fetch-request", this.show.bind(this))
  }

  disconnect() {
    document.removeEventListener("turbo:before-fetch-request", this.show.bind(this))
  }

  show() {
    this.forecastTarget.innerHTML = this.spinnerTarget.innerHTML
  }
}