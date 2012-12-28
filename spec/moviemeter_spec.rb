require 'spec_helper'
require 'moviemeter'

describe Moviemeter do
  before(:all) do
    config = YAML.load_file(File.join(File.dirname(__FILE__), "config.yml"))
    @client = Moviemeter::Client.new(config['api_key'])
  end

  after(:all) do
  	@client.close_session
  end

  describe "search" do
    it "should return results" do
      results = @client.search("Inception")
      results.count.should be > 0
      results[0]['title'].should == "Inception"
    end

    it "should return no results on bogus search" do
      results = @client.search("Some Bogus Title")
      results.count.should == 0
    end
  end

  describe "movie" do
  	it "should return movie info" do
  		movie = @client.movie_by_id(59666)
      movie.should be_a(Moviemeter::Movie)
      movie.id.should be_a(Integer)
      movie.id == 59666
			movie.title.should == "Inception"
			movie.year.should == 2010
			movie.reviews.count.should > 0
			movie.imdb_id.should == "tt1375666"
      movie.imdb_score.should be_a(Float)
      movie.imdb_score.should > 8.0 # should be a fairly safe assumption ;-)
			movie.imdb_votes.should > 0
			movie.votes.should > 0
			movie.score.should > 0
      movie.plot.should_not be_nil
      movie.countries.first.should == "Verenigde Staten"
      movie.directors.first.should == "Christopher Nolan"
  	end

    it "should return movie info by imdb id" do
      movie = @client.movie_by_imdb_id("tt1375666")
      movie.should be_a(Moviemeter::Movie)
      movie.id == 59666
      movie.title.should == "Inception"
      movie.year.should == 2010
      movie.reviews.count.should > 0
      movie.imdb_id.should == "tt1375666"
      movie.imdb_score.should > 8.0 # should be a fairly safe assumption ;-)
      movie.imdb_votes.should > 0
      movie.votes.should > 0
      movie.score.should > 0
      movie.plot.should_not be_nil
      movie.countries.first.should == "Verenigde Staten"
      movie.directors.first.should == "Christopher Nolan"
    end

    it "should handle movies without imdb info" do
      movie = @client.movie_by_id(75867)
      movie.title.should == "Zwarte Soldaten"
      movie.imdb_id.should be_nil
      movie.imdb_score.should be_nil
      movie.imdb_votes.should be_nil
    end

    it "should return image data" do
      images = @client.images_by_movie_id(59666)
      images.count.should > 0
      images.first.filetype.should == 'jpg'
      images.first.type.should == 'image'
      images.first.encoded_contents.should_not == nil
    end
  end

  describe "tvguide" do
    it "should return tv guide with screenings" do
      screenings = @client.tv_guide
      screenings.count.should > 0
      screenings.first.should be_a(Moviemeter::Screening)
      screenings.first.movie.should be_a(Moviemeter::Movie)
    end

    it "should retrieve extended tv guide with screenings" do
      screenings = @client.tv_guide(false)
      screenings_extended = @client.tv_guide(true)
      screenings_extended.count.should > screenings.count
      screenings_extended.first.should be_a(Moviemeter::Screening)
      screenings_extended.first.movie.should be_a(Moviemeter::Movie)      
    end
  end

  describe "cinema" do
    it "should return cinema movies" do
      releases = @client.cinema_movies
      releases.count.should > 0
      releases.first.date.should be_a_kind_of(Date)
      releases.first.movie.should be_a_kind_of(Moviemeter::Movie)
    end
  end

  describe "director" do
    it "should return directors on search" do
      directors = @client.director_search("Christopher Nolan")
      directors.count.should > 0
      directors.first.should be_a(Moviemeter::Director)
      directors.first.movies.count.should > 0
      directors.first.movies.collect { |m| m.title }.should include "Inception"
    end

    it "should return one director by its id" do
      director = @client.director_by_id(2128)
      director.should be_a(Moviemeter::Director)
      director.id.should == 2128
      director.name.should == "Christopher Nolan"
    end
  end

end