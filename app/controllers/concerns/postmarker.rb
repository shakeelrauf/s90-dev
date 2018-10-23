# Use the 'postmark' gem to send the email
module Postmarker extend ActiveSupport::Concern
  include ApplicationHelper
  # A simpler error sender
  def send_error(subject, content="")
    # The exception message
    if ($!.present?)
      content += "Exception message: #{$!} <br>"
      content += "<br>"
    end
    # The stack trace
    if ($@.present?)
      $@.each do |i|
        content += "#{i}<br>"
      end
    end
    send_email(subject, content, "patrice@patricegagnon.com")
  end

  def send_email(subject, content, to, attachments=[])
    from = "support@jowabo.com"
    client = Postmark::ApiClient.new(ENV['POSTMARK_API_TOKEN'])
    client.deliver(from: from,
                  to: to,
                  subject: subject,
                  html_body: content)
  end
end
