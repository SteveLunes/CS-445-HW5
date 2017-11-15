class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def find_with_same_director
    Movie.where(director: self.director)
  end
=begin
  def self.find_with_same_director(id)
    director = Movie.find_by(title: id).director
    return nil if director.blank? or director.nil?
    Movie.where(director: director).pluck(:title)
  end
=end
end