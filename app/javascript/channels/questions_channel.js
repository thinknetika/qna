import consumer from "./consumer"

document.addEventListener("DOMContentLoaded", () => {
  const questionsList = document.getElementById("questions");

  consumer.subscriptions.create("QuestionsChannel", {
    connected() {
      console.log("question channel connected");
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      switch (data.action) {
        case 'create':
          this.addQuestion(data.question_html);
          break;
        case 'update':
          this.updateQuestion(data.question_html, data.question_id);
          break;
        case 'destroy':
          this.deleteQuestion(data.question_id);
          break;
        default:
          console.log("Unknown action:", data.action);
      }
    },

    addQuestion(questionHTML) {
      if (!questionsList) {
        console.warn("Question list not found.");
        return;
      }

      questionsList.insertAdjacentHTML("beforeend", questionHTML);
    },

    updateQuestion(questionHTML, questionId) {
      const questionElement = document.getElementById(`question_${questionId}`);
      if (!questionElement) {
        console.warn(`Question element with id ${questionId} not found.`);
        return;
      }
      questionElement.innerHTML = questionHTML;
    },

    deleteQuestion(questionId) {
      const questionElement = document.getElementById(`question_${questionId}`);
      if (questionElement) {
        questionElement.remove();
      } else {
        console.warn(`Question element with id ${questionId} not found for deletion.`);
      }
    }
  });
});
