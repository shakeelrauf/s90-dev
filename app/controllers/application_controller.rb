class ApplicationController < ActionController::Base
  include SessionRole
  include Postmarker
  include ErrorHandler
  include Field::FormFields
  include Field::FormFieldUpdater
  include ApplicationHelper
  include Role

  # protect_from_forgery with: :exception
  helper_method :is_artist?, :is_manager?, :is_admin?, :current_user, :t, :current_user_id

  before_action PreFilter

  rescue_from ActionController::RoutingError, with: :routing_defect
  rescue_from Exception, :with => :internal_server_defect

  def log_user_info
    if (has_session?)
      logger.info "===> Name:   #{current_user.name}"
      logger.info "===> Email:  #{current_user.email}"
      logger.info "===> IP:     #{request.ip}"
    else
      logger.info "===> No session"
    end
  end

  # The action parameters
  def actp
    params[:actp]
  end

  def act
    responded = self.send(params[:actp])
    render params[:actp].to_sym if (request.get? && responded != true)
  end
end
