class StoreController < ApplicationController
  skip_before_action :login_required

	def create_qr
		@q = Store::Code.create	
		redirect_to codes_path
	end

	def codes
		@q = Store::Code.last
	end
end
