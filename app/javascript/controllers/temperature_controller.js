import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["value", "f", "c"]
  static values = { temperature: Number }
  currentUnit = "F"

  connect() {
    this.originalTemp = Number(this.valueTarget.textContent)
    this.showF()
  }

  toC(event) {
    event.preventDefault()
    if (this.currentUnit === "C") return
    const c = Math.round((this.originalTemp - 32) * 5 / 9)
    this.valueTarget.textContent = c
    this.currentUnit = "C"
    this.cTarget.classList.add("underline")
    this.fTarget.classList.remove("underline")
  }

  toF(event) {
    event.preventDefault()
    if (this.currentUnit === "F") return
    this.valueTarget.textContent = this.originalTemp
    this.currentUnit = "F"
    this.fTarget.classList.add("underline")
    this.cTarget.classList.remove("underline")
  }

  showF() {
    this.valueTarget.textContent = this.originalTemp
    this.fTarget.classList.add("underline")
    this.cTarget.classList.remove("underline")
  }
}