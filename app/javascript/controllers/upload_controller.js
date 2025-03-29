import { Controller } from "@hotwired/stimulus";
import { DirectUpload } from "@rails/activestorage";

export default class extends Controller {
    static targets = ["input"];

    uploadFile() {
        Array.from(this.inputTarget.files).forEach((file) => {
            const upload = new DirectUpload(
                file,
                this.inputTarget.dataset.directUploadUrl,
            );
            upload.create((error, blob) => {
                if (error) {
                    console.log(error);
                } else {
                    this.createHiddenBlobInput(blob);
                }
            });
        });
    }

    createHiddenBlobInput(blob) {
        const hiddenField = document.createElement("input");
        hiddenField.setAttribute("type", "hidden");
        hiddenField.setAttribute("value", blob.signed_id);
        hiddenField.name = this.inputTarget.name;
        this.element.appendChild(hiddenField);
    }
}
