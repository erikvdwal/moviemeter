module Moviemeter
	class Review
		attr_reader :id, :username, :score, :avatar_url

		def	initialize(values)
			@id = values['messageId'].to_i
			@username = values['username']
			@score = values['user_vote'].to_f
			@avatar_url = values['url_avatar']
			@message = values['message']
		end
	end
end