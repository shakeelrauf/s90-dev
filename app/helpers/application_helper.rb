module ApplicationHelper
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

  def t(s)
    I18n.t(s)
  end
end
