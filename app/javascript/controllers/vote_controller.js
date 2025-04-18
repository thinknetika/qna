import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "rating", "error" ]
    static values = {
        voted: Boolean,
        voteValue: Number
    }

    vote(event) {
        event.preventDefault();

        const button = event.target.closest('button');
        const url = event.target.closest('form').action;
        const method = event.target.closest('form').method;

        fetch(url, {
            method: method,
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
            }
        })
            .then(response => response.json())
            .then(data => {
                if (data.error) {
                    this.errorTarget.textContent = data.error;
                } else if (data.errors) {
                    this.errorTarget.textContent = data.errors.join(', ');
                } else {
                    this.errorTarget.textContent = "";
                    this.ratingTarget.textContent = data.rating;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                this.errorTarget.textContent = "An error occurred.";
            });
    }
}
