class GoogleAuthenticationController < ApplicationController
  before_action :google_client

  def callback
    @client = Signet::OAuth2::Client.new(client_options)
    @client.code = params[:code]
    response = @client.fetch_access_token!
    session[:authorization] = response
    redirect_to calendars_url
  end

  def calendars
    @client.update!(session[:authorization])
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client
    @calendar_list = service.list_calendar_lists
  end

  def auth
    @client = Signet::OAuth2::Client.new(client_options)
    redirect_to @client.authorization_uri.to_s
  end

  def events
    @client = Signet::OAuth2::Client.new(client_options)
    @client.update!(session[:authorization])
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client

    @event_list = service.list_events(params[:calendar_id])
  end

  private

  def client_options
    {
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_SECRET_ID'],
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: callback_url
    }
  end

  def google_client
    @client = Signet::OAuth2::Client.new(client_options)
  end
end
