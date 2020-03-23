class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def movies_same_director
    director = self.director
    return nil if director.blank?
    movies = Movie.where(:director => director)
    return {director: director, movies: movies}
  end
end
