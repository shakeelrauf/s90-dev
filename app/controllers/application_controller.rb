class ApplicationController < ActionController::Base
  include SessionRole
  include Postmarker
  include Field::FormFields
  include Field::FormFieldUpdater
  include ApplicationHelper
  include Role
  # protect_from_forgery with: :exception
  helper_method :is_artist?, :is_manager?, :is_admin?,:current_user,:t, :current_user_id

  before_action PreFilter


  def log_user_info
    if (has_session?)
      logger.info "===> Name:   #{current_user.name}"
      logger.info "===> Email:  #{current_user.email}"
      logger.info "===> IP:     #{request.ip}"
    else
      logger.info "===> No session"
    end
  end
end
