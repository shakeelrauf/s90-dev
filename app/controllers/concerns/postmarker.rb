# Use the 'postmark' gem to send the email
module Postmarker extend ActiveSupport::Concern
  include ApplicationHelper

  # No longer used, we use ApplicationHelper email_error instead
  # A simpler error sender
  # def send_error(subject, content="")
  #   # The exception message
  #   if ($!.present?)
  #     content += "Exception message: #{$!} <br>"
  #     content += "<br>"
  #   end
  #   # The stack trace
  #   if ($@.present?)
  #     $@.each do |i|
  #       content += "#{i}<br>"
  #     end
  #   end
  #   send_email(subject, content, ENV['ERROR_RECIPIENT']) if (ENV['ERROR_RECIPIENT'].present?)
  # end

  def send_email(subject, content, to, attachments=[])
    from = "support@jowabo.com"
    client = Postmark::ApiClient.new(ENV['POSTMARK_API_TOKEN'])
    client.deliver(from: from,
                  to: to,
                  subject: subject,
                  html_body: content)
  end
end
