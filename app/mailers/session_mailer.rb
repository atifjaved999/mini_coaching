class SessionMailer < ApplicationMailer
  def session_notification(user, session)
    @user = user
    @session = session
    @role = @user.roles.first.name.titleize

    mail(
      to: @user.email,
      subject: "New Coaching Session: #{@session.title}"
    )
  end
end
