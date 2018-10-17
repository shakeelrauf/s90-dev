class ApiController < ActionController::Base
  include Postmarker
  include Field::FormFields
  include Field::FormFieldUpdater
  include ApplicationHelper
  include Role



  def render_json_response(resource, status)
    render json: resource.to_json, status: status, adapter: :json_api
  end


end
