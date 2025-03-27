module QuestionsHelper
  def show_view(question)
    request.params[:action] == "show" || request.referrer&.include?(question_path(question))
  end

  def delete_link_with_conditional_turbo_frame(question, css_class)
    options = {
      method: :delete,
      data: {
        turbo_method: :delete,
        turbo_confirm: "Are you sure"
      },
      class: css_class
    }

    options[:data][:turbo_frame] = "_top" if show_view(question)

    link_to "Delete", question_path(question), options
  end
end
