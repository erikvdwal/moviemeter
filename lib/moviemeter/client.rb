module Moviemeter
	class Client
		attr_writer :api_key, :session_key

		def initialize(api_key)
			@api_key = api_key
		end

		def search(title)
			results = rpc_client.call('film.search', session_key, title);
			results.map! do |r|
				{
					'id'                => r['filmId'],
					'title'             => r['title'],
					'alternative_title' => r['alternative_title'],
					'year'              => r['year'].to_i,
					'url'               => r['url'],
					'thumbnail'         => r['thumbnail'],
					'rating'            => r['average'].to_f,
					'votes'             => r['votes_count'].to_i,
					'similarity'        => r['similarity'],
					'duration'          => r['duration'].to_i,
					'directors_text'    => r['directors_text'],
					'actors_text'       => r['actors_text'],
					'genres_text'       => r['genres_text']
				}
			end
		end

		def movie_by_id(movie_id)
			data = rpc_client.call("film.retrieveDetails", session_key, movie_id)
			Movie.new(data, self)
		end

		def movie_by_imdb_id(imdb_id)
			movie_id = rpc_client.call("film.retrieveByImdb", session_key, imdb_id)
			movie_by_id(movie_id.to_i)
		end

		def imdb_info_by_movie_id(movie_id)
			begin
				rpc_client.call("film.retrieveImdb", session_key, movie_id)
			rescue Exception => e
				nil
			end
		end

		def score_info_by_movie_id(movie_id)
			rpc_client.call("film.retrieveScore", session_key, movie_id)
		end

		def reviews_by_movie_id(movie_id)
			data = rpc_client.call("film.retrieveReviews", session_key, movie_id)
		end
		def review_by_id(movie_id, review_id)
			rpc_client.call("film.retrieveReview", session_key, movie_id, review_id)
		end

		def images_by_movie_id(movie_id)
			data = rpc_client.call("film.retrieveImage", session_key, movie_id)
			data.map { |i| Image.new(i) }
		end

		def tv_guide(extended=false)
			method = extended ? "film.retrieveTvAll"  : "film.retrieveTv"
			data = rpc_client.call(method, session_key)
			data.map { |e| e[1].map! { |m| Screening.new(e[0].to_i, m, self) } }.flatten!
		end

		def cinema_movies
			data = rpc_client.call("film.retrieveCinema", session_key)
			data.map { |e| e[1].map! { |m| Release.new(e[0], m, self) } }.flatten!
		end

		def videos
			raise "Not yet implemented"
		end

		def director_search(name)
			directors = rpc_client.call("director.search", session_key, name)
			directors.map { |d| Director.new(d, self) }
		end

		def director_by_id(director_id)
			data = rpc_client.call("director.retrieveDetails", session_key, director_id)
			data['directorId'] = director_id
			Director.new(data, self)
		end

		def movies_by_director_id(director_id)
			data = rpc_client.call("director.retrieveFilms", session_key, director_id)
			data.map { |m| Movie.new(m, self) }
		end

		def close_session
			rpc_client.call("api.closeSession", session_key)
			@session_key = nil
		end

		private
		def rpc_client
			@rpc_client ||= XMLRPC::Client.new2("http://www.moviemeter.nl/ws/", nil, 60)
		end

		def session_key
			if @session_key.nil?
				response = @rpc_client.call("api.startSession", @api_key)
				@session_key = response["session_key"]
			end
			@session_key
		end
	end
end
