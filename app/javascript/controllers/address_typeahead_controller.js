import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "datalist"]
  static values  = { delay: { type: Number, default: 250 } }

  connect() {
    this.timer = null
  }

  query() {
    clearTimeout(this.timer)
    this.timer = setTimeout(() => this.fetchSuggestions(), this.delayValue) //debounce on keypress
  }

  async fetchSuggestions() {
    const q = this.inputTarget.value.trim()
    if (q.length < 3) return // we don't want to spam the API with useless queries
    const url = `https://nominatim.openstreetmap.org/search?format=json&limit=5&countrycodes=us&q=${encodeURIComponent(q)}`

    const res  = await fetch(url, { headers: { "Accept": "application/json" } })
    const json = await res.json()

    this.datalistTarget.innerHTML = ""
    json.forEach(place => {
      const option = document.createElement("option")
      option.value = place.display_name
      this.datalistTarget.appendChild(option)
    })
  }
}
