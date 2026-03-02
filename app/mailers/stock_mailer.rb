class StockMailer < ApplicationMailer
  def send_email(user, subject, body)
    mail(
      to: user.email,
      subject: subject,
      body: body,
      content_type: "text/html"
    )
  end
end