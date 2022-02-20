require_relative 'scraper2.rb'



class Search

def scrapeData
scraper = Scraper.new
totalPages = scraper.store_all_courses_page()
File.write('.course-data.json', JSON.dump(scraper.coursePages))


for i in 1..totalPages
    scraper.get_course_info(i)
end

end

def searchStart
puts
puts
puts "Welcome to the CSE course search!"
puts "You have two options"
puts "1. Search for a specefic course"
puts "2. Search for courses in the advanced mode"
print "Enter option (1 or 2): "
choice = gets.chomp!
while (choice != "1" && choice != "2")
puts
puts "You have entered an invalid option!"
print "Enter a valid option (1 or 2): "
choice = gets.chomp!
end
puts
puts
if (choice == "1")
option1
else
option2
end


#puts "You can search by course number, course name, description, prerequisites, instructor name, and course credit hours"
#maybe put an example of what each of these would be, i think there is some ambiguity
#puts "\nPlease enter a field to search by: "
#fieldName = gets
#puts "\nPlease enter what you would like to search in " + fieldName
#user_input = gets

end

def option1
puts "You have selected option 1"
print "Enter a course number (e.g CSE2421): "
courseNum = gets.chomp!
course_number_search(courseNum) # will need to change so it returns somthing


end

def option2
courseNum, courseName, descriptor, instrName, creditHrs = nil, nil, nil, nil, nil
continue = true
puts "You have selected option 2"
while continue
puts "You have the following filter options in advance search"
puts "Note: At least one filter needs to be used in order to recieve results"
puts "1. Course number"
puts "2. Course name"
puts "3. description"
puts "4. instructor name"
puts "5. Amount of credit hours"
print "Enter a filter option (1-5) or type 'exit' to get the results: "
choice = gets.chomp!
while (choice != "1" && choice != "2" && choice != "3" && choice != "4" && choice != "5" && choice != "exit")
puts
puts "You have entered an invalid option!"
print "Enter a valid filter option (1-5) or type 'exit' to get the results: "
choice = gets.chomp!
end
puts
puts
if (choice == "1")
print "Enter a course number (e.g CSE2421): "
courseNum = gets.chomp!
elsif (choice == "2")
print "Enter a course name: "
courseName = gets.chomp!
elsif (choice == "3")
print "Enter a word that is in a description (e.g graphics): "
descriptor = gets.chomp!
elsif (choice == "4")
print "Enter a instructor's name: "
instrName = gets.chomp!
elsif (choice == "5")
print "Enter the amount of credit hours: "
creditHrs = gets.chomp!
elsif (choice == "exit")
continue = false
end
puts
puts

end




end


def course_number_search(courseNum)


end


#scraper = Scraper.new

#this doesn't work idk why probably something dumb
#if(fieldName == "course name")
#    for x in scraper.courseCatalog
#        if x.subCat == user_input 
#            puts x.subCat
#            puts x.title
#            puts x.description
#            print "Instructors: #{x.teachers}\n"
#            print x.minCH
#            if x.minCH != x.maxCH
#                print "-#{x.maxCH}"
#            end
#            puts
#            puts
#        end
#    end
#end

end

search = Search.new
search.scrapeData
search.searchStart



#if statements for each field (i.e. if fieldName == "course name") then search the array of objects to see if user_input == object.title and print those out
#should do error checking for user input too
