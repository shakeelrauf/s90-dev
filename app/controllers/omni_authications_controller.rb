class OmniAuthicationsController < ApplicationController
  	include SessionRole

	def callback
		@p = Person::Artist.where(email: request.env["omniauth.auth"]["info"]["email"]).first
		if @p.present?
      		successful_login(@p, @p.email)
		else
			@p = Person::Artist.new(email: request.env["omniauth.auth"]["info"]["email"],first_name: request.env["omniauth.auth"]["info"]["name"].split(' ').first, last_name: request.env["omniauth.auth"]["info"]["name"].split(' ').last)
			@p.save(validates: false)
      		successful_login(@p, @p.email)
		end
      	respond_ok
	end
end
