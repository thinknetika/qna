import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["answersContainer"];

    connect() {
        this.observer = new MutationObserver(this.reorderAnswers.bind(this));
        this.observe();
        this.reorderAnswers();
    }

    disconnect() {
        this.unobserve();
        this.observer.disconnect();
    }

    observe() {
        this.observer.observe(this.answersContainerTarget, { childList: true, subtree: true });
    }

    unobserve() {
        this.observer.disconnect();
    }

    reorderAnswers() {
        this.unobserve();

        const answersContainer = this.answersContainerTarget;
        const answerFrames = Array.from(answersContainer.querySelectorAll("turbo-frame"));

        const bestAnswerFrame = answerFrames.find(frame => {
            const bestAnswerInput = frame.querySelector("input[type='hidden'][name='best_answer']");
            return bestAnswerInput !== null;
        });

        if (bestAnswerFrame) {
            const remainingFrames = answerFrames.filter(frame => frame !== bestAnswerFrame);
            const newFrames = [bestAnswerFrame, ...remainingFrames];

            answersContainer.innerHTML = "";
            newFrames.forEach(frame => answersContainer.appendChild(frame));
        }

        this.observe();
    }
}
