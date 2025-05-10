import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    processElement(element) {
        this.isSignedIn = document.querySelector('input[name="user_signed_in"]').value === "true";
        const actions = element.querySelectorAll('.authorize-user-actions');

        actions.forEach(action => {
            if (actions && !this.isSignedIn) {
                action.remove();
            }
        });
    }
}
