require 'digest/sha1'
require 'securerandom'

# https://mattbrictson.com/dynamic-rails-error-pages

class DefectController < ApplicationController
  include Postmarker

	def internal_server_defect
    log_user_info
    s = "Internal Server Error"
    logger.error s
    logger.error $!.message if ($!.present?)
    logger.error $@ if ($@.present?)

    email_error(s)

    respond_to do |format|
      format.html { render template: 'defect/internal_server_defect', status: 500 }
      format.json { render json: {:res=>"error", :msg=>request.url}.to_json }
      format.all { render body: nil, status: 500 }
    end
	end

	# In relation of the application controller RoutingError rescue
  def routing_defect
    log_user_info
    s = "Routing Defect #{request.url}"
    logger.error s
    logger.error $!.message if ($!.present?)
    logger.error $@ if ($@.present?)

    # Always in development, in production, only with a session
    email_error(s) if (has_session? || ENV['RAILS_ENV'] == 'development')

    respond_to do |format|
      format.html { render template: 'defect/not_found', status: 404 }
      format.json { render json: {:res=>"error", :msg=>request.url}.to_json }
      format.all { render body: nil, status: 404 }
    end
  end

end
