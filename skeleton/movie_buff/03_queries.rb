def what_was_that_one_with(those_actors)
  # Find the movies starring all `those_actors` (an array of actor names).
  # Show each movie's title and id.
  Movie
    .select(:title, :id)
    .joins(:actors)
    .where(actors: { name: those_actors})
    .group('movies.id')
    .having('COUNT(*) = (?)', those_actors.length)
end

def golden_age
  # Find the decade with the highest average movie score.
  # hash = Hash.new{|h, k| h[k]=Array.new}
  #   array = Movie
  #   .group(:yr)
  #   .order('AVG(score) DESC')
  #   .pluck('AVG(score), (yr/10) * 10')
  #   # .first.last

  #   array.each do |subarr|
  #       hash[subarr[1]] << subarr[0]
  #   end
    
  #   max_yr = 0 
  #   max_score = 0
  #   hash.each do |k, v|
  #     avg = v.sum / v.length
  #       if avg > max_score
  #         max_score = avg 
  #         max_yr = k
  #       end
  #   end
  #   max_yr

  Movie
    .select('AVG(score), ((yr/10) * 10) AS decade')
    .group('decade')
    .order('AVG(score) DESC')
    .first.decade
end

def costars(input_name)
  # List the names of the actors that the named actor has ever
  # appeared with.
  # Hint: use a subquery
  subquery = Movie.select(:id).joins(:actors).where(actors: {name: input_name})
  
  # subquery
  #   .joins(:actors)
  #   .pluck('actors.name')
  Movie
    .joins(:actors)
    .where.not('actors.name = (?)', input_name)
    .where(movies: {id: subquery})
    .pluck('DISTINCT actors.name')
    
end


def actor_out_of_work
  # Find the number of actors in the database who have not appeared in a movie
  Actor
    .left_outer_joins(:movies)
    .pluck('COUNT(*)').first
end

def starring(whazzername)
  # Find the movies with an actor who had a name like `whazzername`.
  # A name is like whazzername if the actor's name contains all of the
  # letters in whazzername, ignoring case, in order.

  # ex. "Sylvester Stallone" is like "sylvester" and "lester stone" but
  # not like "stallone sylvester" or "zylvester ztallone"
     
      sub_strings = whazzername.split("").shuffle.join("")

      Movie
        .joins(:actors)
        .where('actors.name.downcase LIKE (?)', sub_strings)
end

def longest_career
  # Find the 3 actors who had the longest careers
  # (the greatest time between first and last movie).
  # Order by actor names. Show each actor's id, name, and the length of
  # their career.

end
