import AuthorizeController from "controllers/authorize_controller"

export default class extends AuthorizeController {
    static targets = ["answer"]

    answerTargetConnected(element) {
        this.processElement(element);
    }
}
