import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  open() {
    this.modalTarget.classList.remove('hidden')
  }

  close() {
    this.modalTarget.classList.add('hidden')
  }

  selectReason(event) {
    const descriptionField = document.getElementById('pause_description_field')
    if (event.target.value === 'outro') {
      descriptionField.classList.remove('hidden')
    } else {
      descriptionField.classList.add('hidden')
    }
  }

  submit(event) {
    const reason = document.querySelector('input[name="reason"]:checked')
    const description = document.querySelector('textarea[name="description"]')

    if (reason.value === 'outro' && (!description.value || description.value.trim() === '')) {
      event.preventDefault()
      alert('Por favor, descreva o motivo da pausa.')
      return
    }

    this.close()
  }
}
