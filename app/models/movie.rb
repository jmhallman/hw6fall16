class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
class Movie::InvalidKeyError < StandardError ; end
  
  def self.find_in_tmdb(string)



    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    
    movie_results = []

    begin
      if string == ''
        return movie_results
      end
      
      movies = Tmdb::Movie.find(string)
    rescue Tmdb::InvalidApiKeyError
      raise Movie::InvalidKeyError, 'Invalid API key'
    end
      
      if movies == nil
        return movie_results
      end
      
      movies.each do |movieResult|
        rating = Movie.get_rating(movieResult.id)
        movie_results.push({:tmdb_id => movieResult.id, :title => movieResult.title, :rating => rating, :release_date => movieResult.release_date})
      end
      return movie_results
    
  end
  
  def self.get_rating(string)
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    movie_countries = Tmdb::Movie.releases(string)["countries"]
    rating = nil
    movie_countries.each do |country|
      if country["iso_3166_1"] == "US"
        rating = country["certification"]
      else
        rating = 'NR'
      end
    end
    return rating
  end
  
  
  def self.create_from_tmdb(id)
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    begin
      hash = Hash.new
      tmdb_movie = Tmdb::Movie.detail(id)
      hash[:title] = tmdb_movie['title']
      hash[:rating] = self.get_rating(id)
      hash[:release_date] = tmdb_movie['release_date']
      Movie.create!(hash)
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end
  
end
