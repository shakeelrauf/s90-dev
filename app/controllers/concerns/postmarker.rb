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
  
  def send_email_domain(subject, content, to, attachments=[])
    from = "support@cocooningfinance.com"
    client = Postmark::ApiClient.new(ENV['POSTMARK_API_TOKEN_COM'])
    client.deliver(from: from,to: to,subject: subject,html_body: content)
  end

  def send_email(subject, content, to, attachments=[])
    # puts "********************* FROM IS ALWAYS support@cocooningfinance.com, see Postmark signatures"
    from = "support@cocooningfinance.com"
    client = Postmark::ApiClient.new(ENV['POSTMARK_API_TOKEN_COM'])
    client.deliver(from: from,to: to,subject: subject,html_body: content)
  end

  def get_skin
    if (ENV['ADN_SKIN'].present?)
      return ENV['ADN_SKIN']
    elsif (request.domain == 'cocooningfinance.net')
      return 'ccn'
    elsif (request.domain == 'd-a.online')
      return 'dl'
    elsif (request.domain == 'aflsix.com')
      return 'afl'
    end
    return 'tn'
  end


  def send_email_afl(subject, content, to, attachments=[])
    # puts "********************* FROM IS constant, see Postmark signatures"
    reply_to = "Groupe AFL à votre service <b7ca88a88d67eb048c5f8eb66fe0309f@inbound.postmarkapp.com>"
    from = "AFL <afl@aflsix.com>"

    client = Postmark::ApiClient.new("9034b7be-50fd-4cbb-94cb-5d7d07e7f10d")
    client.deliver(from: from,
                   reply_to: reply_to,
                   to: to,
                   subject: subject,
                   html_body: content)
  end

  def send_email(subject, content, to, attachments=[])
    return
    from = "support@waboo.io"

    client = Postmark::ApiClient.new(ENV['POSTMARK_API_TOKEN'])
    client.deliver(from: from,
                  to: to,
                  subject: subject,
                  html_body: content)
  end
end
