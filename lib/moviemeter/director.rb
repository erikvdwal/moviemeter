module Moviemeter
	class Director
		attr_reader :id, :url, :name

		def initialize(values, client)
			@client = client
			
			@id = values['directorId'].to_i unless values['directorId'].nil?
			@url = values['url']
			@name = values['name']
		end

		def movies
			@client.movies_by_director_id(self.id)
		end
	end
end