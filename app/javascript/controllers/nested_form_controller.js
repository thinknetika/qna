// app/javascript/controllers/nested_form_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["template", "fields"]
    static values = {
        associationName: String
    }

    add(event) {
        event.preventDefault()

        let content = this.templateTarget.innerHTML.replace(/NEW_CHILD_ID/g, new Date().getTime())
        this.fieldsTarget.insertAdjacentHTML('beforeend', content)
    }

    remove(event) {
        event.preventDefault()

        let item = event.target.closest(".nested-fields")
        let destroyInput = item.querySelector("input[name*='_destroy']")
        if (destroyInput) {
            destroyInput.value = 1
        }
        item.style.display = 'none'
    }
}
