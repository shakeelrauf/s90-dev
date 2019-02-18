module AuthenticationResponses
	def respond_msg msg
    respond_to do |format|
      format.json { render json: {:msg=>msg}.to_json }
    end
    true
  end

  def respond_res res
    respond_to do |format|
      format.json { render json: {:res=>res}.to_json }
    end
    true
  end

  def render_json_response(resource, status)
    render json: resource.to_json, status: status, adapter: :json_api
  end


  def respond_res_msg res, msg
    respond_to do |format|
      format.json { render json: {:res=>res, :msg=>msg}.to_json }
    end
    true
  end

  def respond_json o
    respond_to do |format|
      format.json { render json: o.to_json }
    end
    true
  end

  def respond_ok(msg = nil)
    (msg.nil?) ? (respond_res 'ok') : (respond_res_msg 'ok', msg)
    true
  end

  def respond_error(msg=t("error.server_error"))
    respond_res_msg 'error', msg
    true
  end

  def respond_msg msg
    respond_to do |format|
      format.json { render json: {:msg=>msg}.to_json }
    end
    true
  end

end