module Api::V1::SessionsHelper

	def user_profile_pic(current_user)
		Api::V1::Parser.parse_artists(current_user,current_user)
	end

end
