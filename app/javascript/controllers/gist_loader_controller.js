import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["placeholder", "content"]
    static values = {
        url: String
    }

    connect() {
        this.loadGist();
    }

    async loadGist() {
        try {
            const gistId = this.urlValue.split('/').pop();
            const response = await fetch(`https://api.github.com/gists/${gistId}`);
            const data = await response.json();

            if (data && data.files) {
                const firstFile = Object.values(data.files)[0];
                const content = firstFile.content;
                this.contentTarget.innerHTML = `<pre><code class="language-${firstFile.language.toLowerCase()}">${content}</code></pre>`;
                this.placeholderTarget.remove();
            } else {
                this.contentTarget.textContent = "Failed to load gist.";
                this.placeholderTarget.remove();
            }
        } catch (error) {
            console.error("Error loading gist:", error);
            this.contentTarget.textContent = "Error loading gist.";
            this.placeholderTarget.remove();
        }
    }
}
