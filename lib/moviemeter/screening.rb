module Moviemeter
	class Screening
		attr_reader :time, :channel, :movie

		def initialize(time, values, client)
			@time = time
			@movie = Movie.new(values, client)
			@channel = values['channel']
		end
	end
end