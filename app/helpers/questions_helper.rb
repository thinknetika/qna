module QuestionsHelper
  def show_view(question)
    return false if request.params[:action] == "index"

    request.params[:action] == "show" || request.referrer&.include?(question)
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

  def subscription_button(question)
    return unless user_signed_in?

    if current_user.subscribed_to?(question)
      link_to 'Unsubscribe',
              question_subscription_path(question),
              method: :delete,
              data: {
                turbo_method: :delete,
                turbo_confirm: "Are you sure"
              },
              class: 'btn btn-outline-secondary'
    else
      link_to 'Subscribe',
              question_subscription_path(question),
              method: :post,
              data: {
                turbo_method: :post
              },
              class: 'btn btn-primary'
    end
  end
end
