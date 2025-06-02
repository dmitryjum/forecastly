import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["spinner", "forecast"]

  connect() {
    document.addEventListener("turbo:before-fetch-request", this.show.bind(this))
    document.addEventListener("turbo:frame-load", this.hide.bind(this))
  }

  disconnect() {
    document.removeEventListener("turbo:before-fetch-request", this.show.bind(this))
    document.removeEventListener("turbo:frame-load", this.hide.bind(this))
  }

  show() {
    this.spinnerTarget.classList.remove("hidden")
    this.forecastTarget.innerHTML = ""
  }

  hide() {
    this.spinnerTarget.classList.add("hidden")
  }
}