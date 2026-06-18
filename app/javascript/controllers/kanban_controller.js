import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "column"]

  connect() {
    this.setupDragAndDrop()
  }

  setupDragAndDrop() {
    this.cardTargets.forEach(card => {
      card.addEventListener('dragstart', this.handleDragStart.bind(this))
      card.addEventListener('dragend', this.handleDragEnd.bind(this))
    })

    this.columnTargets.forEach(column => {
      column.addEventListener('dragover', this.handleDragOver.bind(this))
      column.addEventListener('dragleave', this.handleDragLeave.bind(this))
      column.addEventListener('drop', this.handleDrop.bind(this))
    })
  }

  handleDragStart(event) {
    event.target.classList.add('opacity-50')
    event.dataTransfer.setData('text/plain', event.target.dataset.leadId)
    event.dataTransfer.effectAllowed = 'move'
  }

  handleDragEnd(event) {
    event.target.classList.remove('opacity-50')
    this.columnTargets.forEach(column => {
      column.classList.remove('bg-white/20')
    })
  }

  handleDragOver(event) {
    event.preventDefault()
    event.dataTransfer.dropEffect = 'move'
    event.currentTarget.classList.add('bg-white/20')
  }

  handleDragLeave(event) {
    event.currentTarget.classList.remove('bg-white/20')
  }

  async handleDrop(event) {
    event.preventDefault()
    event.currentTarget.classList.remove('bg-white/20')

    const leadId = event.dataTransfer.getData('text/plain')
    const newStatus = event.currentTarget.dataset.status

    if (!leadId || !newStatus) return

    try {
      const response = await fetch(`/admin/kanban/move`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.getMetaValue('csrf-token'),
          'Accept': 'text/vnd.turbo-stream.html'
        },
        body: JSON.stringify({
          lead_id: leadId,
          new_status: newStatus
        })
      })

      if (response.ok) {
        const turboStream = await response.text()
        Turbo.renderStreamMessage(turboStream)
      } else {
        console.error('Failed to move lead')
      }
    } catch (error) {
      console.error('Error moving lead:', error)
    }
  }

  getMetaValue(name) {
    const element = document.head.querySelector(`meta[name="${name}"]`)
    return element ? element.getAttribute('content') : null
  }
}
