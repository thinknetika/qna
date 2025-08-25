class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.dig(:production, :smtp, :user_name)
  layout "mailer"

  def mail(headers = {})
    super(headers.merge(
      'Reply-To' => Rails.application.credentials.dig(:production, :smtp, :user_name),
      'X-Mailer' => 'Ruby on Rails'
    ))
  end
end
