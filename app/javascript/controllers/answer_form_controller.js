import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "body", "errors" ]

    initialize(){
        this.element.addEventListener("turbo:submit-end", (event) => {
            if (event.detail.success) {
                this.bodyTarget.value = "";
                this.errorsTarget.innerHTML = "";
            }
        });
    }
}
