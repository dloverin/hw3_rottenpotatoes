# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(:title => movie[:title], :release_date => movie[:release_date], 
      :rating => movie[:rating])
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(%r{,\s*}) || []
  ratings.each do |rating|
    step "I #{(uncheck ? "uncheck" : "check")} \"ratings_#{rating}\""
  end
end

Then /I should (not )?see the following movies: (.*)/ do |hidden, rating_list|
  ratings = rating_list.split(%r{,\s*}) || []
  results = all("tbody tr")
  filtered_count = 0
  ratings.each do |rating|
    results.each do |result|
      if (result.text.index("\n#{rating}\n")) 
        filtered_count += 1
      end
    end
  end

  if (hidden)
    filtered_count.should == 0
  else
    movies = Movie.find_all_by_rating(ratings)
    filtered_count.should == movies.length
  end
end

Then /I should see all of the movies/ do
  all_movies = Movie.all
  results = all("tbody tr")
  all_movies.length.should == results.length
end

Then /I should see no movies/ do
  results = all("tbody tr")
  results.length.should == 0
end
