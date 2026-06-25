import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = ["column"]

  connect() {
    this.sortables = this.columnTargets.map(column => this.makeSortable(column))
  }

  disconnect() {
    this.sortables.forEach(s => s.destroy())
  }

  makeSortable(column) {
    return new Sortable(column, {
      group:     "kanban",
      animation: 150,
      ghostClass: "opacity-40",
      dragClass:  "scale-95",
      onEnd: (evt) => this.handleMoved(evt)
    })
  }

  async handleMoved(evt) {
    if (evt.from === evt.to) return

    const leadId   = evt.item.dataset.leadId
    const newStatus = evt.to.dataset.status
    const oldStatus = evt.from.dataset.status

    if (!leadId || !newStatus) return

    this.syncColumnUI(evt.from, oldStatus)
    this.syncColumnUI(evt.to, newStatus)

    try {
      const response = await fetch("/admin/kanban/move", {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.csrfToken,
          "Accept": "text/vnd.turbo-stream.html"
        },
        body: JSON.stringify({ lead_id: leadId, new_status: newStatus })
      })

      if (response.ok) {
        const html = await response.text()
        Turbo.renderStreamMessage(html)
      } else {
        // Revert: move card back and restore counts
        evt.from.insertBefore(evt.item, evt.from.children[evt.oldIndex] || null)
        this.syncColumnUI(evt.from, oldStatus)
        this.syncColumnUI(evt.to, newStatus)
        this.flashError(evt.item)
      }
    } catch (_err) {
      evt.from.insertBefore(evt.item, evt.from.children[evt.oldIndex] || null)
      this.syncColumnUI(evt.from, oldStatus)
      this.syncColumnUI(evt.to, newStatus)
      this.flashError(evt.item)
    }
  }

  syncColumnUI(column, status) {
    this.syncCount(column, status)
    this.syncEmptyState(column)
  }

  syncCount(column, status) {
    const countEl = document.getElementById(`column_count_${status}`)
    if (!countEl) return
    const cards = column.querySelectorAll("[data-lead-id]").length
    countEl.textContent = cards
  }

  syncEmptyState(column) {
    const hasCards = column.querySelector("[data-lead-id]") !== null
    let placeholder = column.querySelector(".kanban-empty")

    if (hasCards) {
      placeholder?.remove()
    } else if (!placeholder) {
      placeholder = document.createElement("div")
      placeholder.className = "kanban-empty flex items-center justify-center py-8 text-slate-300 text-sm"
      placeholder.textContent = "Sem leads"
      column.appendChild(placeholder)
    }
  }

  flashError(card) {
    card.classList.add("ring-2", "ring-red-400")
    setTimeout(() => card.classList.remove("ring-2", "ring-red-400"), 2000)
  }

  get csrfToken() {
    return document.querySelector("meta[name='csrf-token']")?.content
  }
}
