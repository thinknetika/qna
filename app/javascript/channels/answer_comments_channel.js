import consumer from "./consumer"

document.addEventListener("DOMContentLoaded", () => {
  const answersId = document.getElementById('answers');

  if (answersId) {
    const subscribeToAnswerComments = (answerId) => {
      consumer.subscriptions.create({ channel: "AnswerCommentsChannel", answer_id: answerId }, {
        connected() {
          console.log(`Connected to AnswerCommentsChannel for answer ${answerId}`);
        },

        disconnected() {
          console.log(`Disconnected from AnswerCommentsChannel for answer ${answerId}`);
        },

        received(data) {
          switch (data.action) {
            case 'create':
              this.addAnswer(data.comment_html, data.answer_id);
              break;
            case 'update':
              this.updateAnswer(data.comment_html, data.comment_id);
              break;
            case 'destroy':
              this.deleteAnswer(data.comment_id);
              break;
            default:
              console.log("Unknown action:", data.action);
          }
        },

        addAnswer(commentHTML) {
          const answerCommentsList = document.getElementById(`answer_${answerId}_comments`);
          if (answerCommentsList) {
            answerCommentsList.insertAdjacentHTML("beforeend", commentHTML);
          } else {
            console.warn("Answer comments not found.");
          }
        },

        updateAnswer(commentHTML, commentId) {
          const commentElement = document.getElementById(`comment_${commentId}`);
          if (commentElement) {
            commentElement.innerHTML = commentHTML;
          } else {
            console.warn(`Answer comment element with id ${commentId} not found.`);
          }
        },

        deleteAnswer(commentId) {
          const commentElement = document.getElementById(`comment_${commentId}`);
          if (commentElement) {
            commentElement.remove();
          } else {
            console.warn(`Answer comment element with id ${commentId} not found for deletion.`);
          }
        }
      });
    };

    const subscribeToAllAnswerComments = () => {
      const answerFrames = document.querySelectorAll('turbo-frame[id^="answer_"]');

      const answerIds = Array.from(answerFrames).map(frame => frame.id);

      answerIds.forEach(answerId => {
        subscribeToAnswerComments(answerId.replace('answer_', ''));
      });
    };

    subscribeToAllAnswerComments();
  }
});
