module Moviemeter
	class Release
		attr_reader :date, :movie

		def initialize(date, values, client)
			@date = Date.strptime(date.gsub('00', '01'), '%Y-%m-%d')
			@movie = Movie.new(values, client)
		end
	end
end