class Movie < ActiveRecord::Base

  def self.get_all_ratings
    ratings = self.select(:rating).uniq

    ratings.collect do |rating|
      rating.rating
    end
  end
end
