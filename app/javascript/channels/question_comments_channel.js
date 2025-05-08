import consumer from "./consumer"

document.addEventListener("DOMContentLoaded", () => {
  const questionFrame = document.querySelector('turbo-frame[id^="question_"]');
  const questionCommentsId = document.getElementById('question_comments');

  if (questionCommentsId) {
    const questionId = parseInt(questionFrame.id.replace('question_', ''), 10);

    consumer.subscriptions.create({channel: "QuestionCommentsChannel", question_id: questionId}, {
      connected() {
        console.log(`Connected to QuestionCommentsChannel for question ${questionId}`);
      },

      disconnected() {
        console.log(`Connected to QuestionCommentsChannel for question ${questionId}`);
      },

      received(data) {
        switch (data.action) {
          case 'create':
            this.addAnswer(data.comment_html);
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
        const questionCommentsList = document.getElementById('question_comments');
        if (questionCommentsList) {
          questionCommentsList.insertAdjacentHTML("beforeend", commentHTML);
        } else {
          console.warn("Question comments not found.");
        }
      },

      updateAnswer(commentHTML, commentId) {
        const commentElement = document.getElementById(`comment_${commentId}`);
        if (commentElement) {
          commentElement.innerHTML = commentHTML;
        } else {
          console.warn(`Question comment element with id ${commentId} not found.`);
        }
      },

      deleteAnswer(commentId) {
        const commentElement = document.getElementById(`comment_${commentId}`);
        if (commentElement) {
          commentElement.remove();
        } else {
          console.warn(`Question comment element with id ${commentId} not found for deletion.`);
        }
      }
    });
  }
});
