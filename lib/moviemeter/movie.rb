module Moviemeter
	class Movie
		attr_reader :id, :title, :year, :reviews, :url, :alternative_titles, :plot, :actors, :duration, :directors, :countries, :genres, :cinema_dates, :video_dates, :score, :votes

		def initialize(values, client)
			@client = client			

			@id = values['filmId'].to_i
			@title = values['title']
			@year = values['year'].to_i
			@url = values['url']
			@alternative_titles = values['alternative_titles']
			@plot = values['plot']
			@duration = values['duration'].to_i
			@actors = values['actors'].collect { |a| a['name'] } unless values['actors'].nil?
			@directors = values['directors'].collect { |d| d['name'] } unless values['directors'].nil?
			@countries = values['countries'].collect { |c| c['name'] } unless values['countries'].nil?
			@genres = values['genres']
			@cinema_dates = values['dates_cinema'].collect { |c| c['date'] } unless values['dates_cinema'].nil?
			@video_dates = values['dates_video'].collect { |c| c['date'] } unless values['dates_video'].nil?
			@score = values['average'].to_f
			@votes = values['votes_count'].to_i
		end

		def reviews
			@reviews ||= @client.reviews_by_movie_id(self.id)
		end

		# def score
		# 	score_info['average'].to_f
		# end

		# def votes
		# 	score_info['votes'].to_i
		# end

		# def score_info
		# 	@score_info ||= @client.score_info_by_movie_id(self.id)
		# end

		def imdb_score
			imdb_info['score'].to_f unless imdb_info.nil?
		end

		def imdb_votes
			imdb_info['votes'].to_i unless imdb_info.nil?
		end

		def imdb_id
			"tt#{imdb_info['code']}" unless imdb_info.nil?
		end

		def imdb_info
			@imdb_info ||= @client.imdb_info_by_movie_id(self.id)
		end
	end
end