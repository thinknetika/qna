import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "answer_body", "errors" ]

    initialize(){
        this.element.addEventListener("turbo:submit-end", (event) => {
            if (event.detail.success) {
                this.answer_bodyTarget.value = "";
                this.errorsTarget.innerHTML = "";
            }
        });
    }
}
