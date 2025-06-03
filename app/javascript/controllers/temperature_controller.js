import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["value", "f", "c"]
  initialize() {
    this.originalTemps = {};
    this.currentUnit = "F";
  }

  connect() {
    this.valueTargets.forEach(element => {
      this.originalTemps[element.id] = Number(element.attributes["data-original"].value);
    });
    this.showF();
  }

  toC(event) {
    event.preventDefault();
    if (this.currentUnit === "C") return;
    this.valueTargets.forEach(element => {
      const original = this.originalTemps[element.id];
      const celsius = Math.round((original - 32) * 5 / 9);
      element.querySelector("span").textContent = celsius;
    });
    this.currentUnit = "C";
    this.cTarget.classList.add("underline");
    this.fTarget.classList.remove("underline");
  }

  toF(event) {
    event.preventDefault();
    if (this.currentUnit === "F") return;
    this.valueTargets.forEach(element => {
      element.querySelector("span").textContent = this.originalTemps[element.id];
    });
    this.currentUnit = "F";
    this.fTarget.classList.add("underline");
    this.cTarget.classList.remove("underline");
  }

  showF() {
    this.fTarget.classList.add("underline");
    this.cTarget.classList.remove("underline");
  }
}