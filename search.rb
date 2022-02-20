require_relative 'scraper.rb'

puts "Welcome to the CSE course search!"
puts "You can search by course number, course name, description, prerequisites, instructor name, and course credit hours"
puts "\nPlease enter a field to search by: "
fieldName = gets
puts "\nPlease enter what you would like to search in " + fieldName
user_input = gets


#if statements for each field (i.e. if fieldName == "course name") then search the array of objects to see if user_input == object.title and print those out
#should do error checking for user input too