require_relative 'scraper.rb'

puts "Welcome to the CSE course search!"
puts "You can search by course number, course name, description, prerequisites, instructor name, and course credit hours"
#maybe put an example of what each of these would be, i think there is some ambiguity
puts "\nPlease enter a field to search by: "
fieldName = gets
puts "\nPlease enter what you would like to search in " + fieldName
user_input = gets

scraper = Scraper.new

#this doesn't work idk why probably something dumb
if(fieldName == "course name")
    for x in scraper.courseCatalog
        if x.subCat == user_input 
            puts x.subCat
            puts x.title
            puts x.description
            print "Instructors: #{x.teachers}\n"
            print x.minCH
            if x.minCH != x.maxCH
                print "-#{x.maxCH}"
            end
            puts
            puts
        end
    end
end

#if statements for each field (i.e. if fieldName == "course name") then search the array of objects to see if user_input == object.title and print those out
#should do error checking for user input too