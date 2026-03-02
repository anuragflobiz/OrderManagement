class OtpMailer < ApplicationMailer
  def send_otp(email, otp, purpose)
    @otp = otp
    @purpose = purpose

    mail(
      to: email,
      subject: "Your OTP for #{purpose.capitalize}"
    )
  end
end