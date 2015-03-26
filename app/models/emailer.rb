class Emailer < ActionMailer::Base
  def send_email(from_email, to_email, subject, text_body)
    Rails.logger.debug "[Emailer#send_email] from_email: #{from_email}, to_email: #{to_email}, subject: #{subject}, text_body: #{text_body}"
    mail(from: from_email, to: to_email, subject: subject) do |format|
      format.text { render text: text_body }
    end
  end
end
