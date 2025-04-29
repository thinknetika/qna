import consumer from "./consumer"

document.addEventListener("DOMContentLoaded", () => {
    const questionFrame = document.querySelector('turbo-frame');

    if (questionFrame) { // Проверяем, что turbo-frame существует
        const questionId = parseInt(questionFrame.id.replace('question_', ''), 10);

        consumer.subscriptions.create({channel: "AnswersChannel", question_id: questionId}, {
            connected() {
                console.log(`Connected to AnswersChannel for question ${questionId}`);
            },

            disconnected() {
                console.log(`Disconnected from AnswersChannel for question ${questionId}`);
            },

            received(data) {
                switch (data.action) {
                    case 'create':
                        this.addAnswer(data.answer_html);
                        break;
                    case 'update':
                        this.updateAnswer(data.answer_html, data.answer_id);
                        break;
                    case 'destroy':
                        this.deleteAnswer(data.answer_id);
                        break;
                    default:
                        console.log("Unknown action:", data.action);
                }
            },

            addAnswer(answerHTML) {
                const answersList = document.getElementById('answers');
                if (answersList) {
                    answersList.insertAdjacentHTML("beforeend", answerHTML);
                } else {
                    console.warn("Answers not found.");
                }
            },

            updateAnswer(answerHTML, answerId) {
                const answerElement = document.getElementById(`answer_${answerId}`);
                if (answerElement) {
                    answerElement.innerHTML = answerHTML;
                } else {
                    console.warn(`Answer element with id ${answerId} not found.`);
                }
            },

            deleteAnswer(answerId) {
                const answerElement = document.getElementById(`answer_${answerId}`);
                if (answerElement) {
                    answerElement.remove();
                } else {
                    console.warn(`Answer element with id ${answerId} not found for deletion.`);
                }
            }
        });
    } else {
        console.warn("Turbo frame not found.");
    }
});
