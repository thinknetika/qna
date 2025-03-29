module ApplicationHelper
  def render_file_with_deletion_link(file, source)
    link_to (source.try(:question) ? delete_file_answer_path(source, file_id: file.id) : delete_file_question_path(source, file_id: file.id)), data: { turbo_method: :delete, confirm: "Вы уверены?" }, class: "position-absolute top-0 end-0 text-danger", style: "font-size: 0.8em;" do
      content_tag(:i, "", class: "fas fa-times-circle")
    end
  end
end
