module QuestionsHelper
  def delete_link_with_conditional_turbo_frame(question, source_view)
    options = {
      method: :delete,
      data: {
        turbo_method: :delete,
        turbo_confirm: "Are you sure"
      }
    }

    # Add turbo_frame if source_view is 'index'
    options[:data][:turbo_frame] = "_top" if source_view == "show"

    link_to "Delete", question_path(question, source_view: source_view), options
  end
end
