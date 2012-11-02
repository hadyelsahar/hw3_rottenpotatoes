# Add a declarative step here for populating the DB with movies.


Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    row = Movie.create!(movie);
  end
end


# Make sure that one string (regexp) occurs before or after another one
#   on the same page
Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  pos1 = 0 ;
  pos2 = 0 ;
  count = 0 ;
  page.all('tbody tr td:eq(1)').map do |td|
    count = count + 1 
    if td.text == e1
      pos1 = count;
      
    elsif td.text == e2
      pos2 = count;
      
    end
  end
 
success = pos1 < pos2
success.should == true 
end

# make sure that all movies exist
Then /^I should see all of the movies$/ do
   
  rows = page.all('tbody tr').count
  rows.should == Movie.count(:all)
 
end

# make sure that no movies exist
Then /^I should see no movies$/ do
   
  rows = page.all('tbody tr').count
  rows.should == 0
 
end

# make sure that all movies of a special rating exists 
Then /^I should see all "(.*)" rated movies$/ do |rating|
  count = 0 
  page.all('tbody tr td:eq(2)').map do |td|
    if td.text == rating
      count = count + 1 
    end
  end
  count.should == Movie.where(:rating => rating).all.count()
end

# make sure that all movies of a special rating doesn't exists 
Then /^I should not see all "(.*)" rated movies$/ do |rating|
  count = 0 
  page.all('tbody tr td:eq(2)').map do |td|
    if td.text == rating
      count = count + 1
    end
  end
  count.should == 0
end



# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  fields = rating_list.split(%r{\s*,\s*})
  fields.each do |field|
    if !uncheck
      check("ratings_"+field)
    else  
      uncheck("ratings_"+field)
    end
  end
end

#check and uncheck all the movies
Given /^I (un)?check all ratings$/ do |uncheck|
  page.all("[type='checkbox']").each do |checkbox|
    if !uncheck
      check(checkbox[:id])
    else
      uncheck(checkbox[:id])    
    end
  end
end 



