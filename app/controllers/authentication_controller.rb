class AuthenticationController < ActionController::Base
  include SessionRole
  include Postmarker
  include Field::FormFields
  include Field::FormFieldUpdater
  include ApplicationHelper
  include Role
  # protect_from_forgery with: :exception
  helper_method :is_artist?, :is_admin?,:current_user,:t, :current_user_id
  
  before_action PreFilter
end
