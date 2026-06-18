import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "status"]
  static values = { url: String, workSessionId: String }

  connect() {
    this.startPolling()
    this.updateTimer()
  }

  disconnect() {
    this.stopPolling()
  }

  startPolling() {
    this.pollingInterval = setInterval(() => {
      this.fetchTimerState()
    }, 1000)
  }

  stopPolling() {
    if (this.pollingInterval) {
      clearInterval(this.pollingInterval)
    }
  }

  async fetchTimerState() {
    try {
      const response = await fetch(this.urlValue)
      const data = await response.json()
      
      if (data.elapsed_seconds) {
        this.displayTarget.textContent = this.formatTime(data.elapsed_seconds)
      }
      
      if (data.status) {
        this.statusTarget.textContent = this.getStatusText(data.status, data.paused)
      }
    } catch (error) {
      console.error("Error fetching timer state:", error)
    }
  }

  updateTimer() {
    // Initial update
    this.fetchTimerState()
  }

  formatTime(seconds) {
    const hours = Math.floor(seconds / 3600)
    const minutes = Math.floor((seconds % 3600) / 60)
    const secs = seconds % 60
    
    return [
      hours.toString().padStart(2, '0'),
      minutes.toString().padStart(2, '0'),
      secs.toString().padStart(2, '0')
    ].join(':')
  }

  getStatusText(status, paused) {
    if (paused) return "Pausado"
    if (status === "active") return "Em andamento"
    return "Aguardando"
  }
}
