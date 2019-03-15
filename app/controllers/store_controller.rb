class StoreController < AdminController

	# Code generation prototype for an artist
	def create_qr
		@q = Store::Code.create(:album_id=>Album::Album.last.id)	
		redirect_to codes_path
	end

	def codes
		@q = Store::Code.last
	end
end
