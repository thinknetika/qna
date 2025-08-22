import AuthorizeController from "controllers/authorize_controller"

export default class extends AuthorizeController {
    static targets = ["question"]

    questionTargetConnected(element) {
        this.processElement(element);
    }
}
