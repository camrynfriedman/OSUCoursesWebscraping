require_relative 'scraper2.rb'

<<<<<<< HEAD


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
=======
#used to print information about each course
def print_values(x)
    puts
    puts
    puts x.subCat
    puts x.title
    puts x.description
    print "Instructors: #{x.teachers}\n"
    print "Credit Hours: " + x.minCH.to_s
    if x.minCH != x.maxCH
        print "-#{x.maxCH}"
    end
    puts
    puts
end

#initializing scraper
scraper = Scraper.new
totalPages = scraper.store_all_courses_page()

for i in 1..totalPages
    scraper.get_course_info(i)
end

#welcome message
puts "\nWelcome to the CSE course search!"
puts "You can search by course number, course name, description, instructor name, and course credit hours"
puts "Enter 1 for the course number (i.e. 'MATH2568')"
puts "Enter 2 for the course name (i.e. 'Linear Algebra')"
puts "Enter 3 to search for a word in the description (i.e. 'Prereq')" #can use the include? method for strings here if x.description.include? "prereq"
puts "Enter 4 to search by instructor"
puts "Enter 5 to search for course credit hours"

puts "\nPlease enter a field to search by: "
fieldName = gets.to_i

while !fieldName.between?(1,5)
    puts "\nPlease enter a valid field number"
    fieldName = gets.to_i
end

count = 0 #to keep track of how many results show up after the search. also helpful for printing error message

#course number
if fieldName == 1
    puts "\nPlease enter what course you would like to search for by providing the name and number with no spaces (i.e. MATH2568): "
    user_input = gets
    user_input = user_input.upcase
    puts "\n\nSearch Results:"
    scraper.courseCatalog.each do |x|
        if user_input.chomp == x.subCat
            print_values(x)
            count += 1

        end
    end

#course name
elsif fieldName == 2
    puts "\nPlease enter what course title you would like to search for (i.e. 'Linear Algebra'): "
    user_input = gets.chomp
    user_input = user_input.upcase
    puts "\n\nSearch Results:"
    scraper.courseCatalog.each do |x|
        if x.title.upcase.include?(user_input) #if user types "software" all classes with that word will show up in results
            print_values(x)
            count += 1
        end
    end

#description
elsif fieldName == 3
    puts "\nPlease enter a keyword(s) from the course description (i.e. 'Prereq'): "
    user_input = gets.chomp
    user_input = user_input.upcase
    puts "\n\nSearch Results:"
    scraper.courseCatalog.each do |x|
        unless x.description.nil?
            if x.description.upcase.include?(user_input)
                print_values(x)
                count += 1
            end
        end
    end

#instructor
elsif(fieldName == 4)
    puts "\nPlease enter the instructor's full name: "
    user_input = gets.chomp
    #tokenize and capitalize user input
    tokenized_user_input = user_input.upcase.split
    puts "\n\nSearch Results:"
    scraper.courseCatalog.each do |x|
        #TODO - take into account that some professors have their entire name (i.e. Adam Russell Grupa) listed so if
        #someone tries to search "Adam Grupa" and finds nothing because they didn't type in "Adam Russell Grupa"
        #teachers_uppercase = x.teachers.map(&:upcase)
        i=0
        while i<x.teachers.length
            name = x.teachers[i].upcase.split
            if name.include? (tokenized_user_input[0] and tokenized_user_input[tokenized_user_input.length-1])
                print_values(x)
                count+=1
            end
            i+=1
        end

    end

#credit hours
elsif(fieldName == 5)
    puts "\nPlease enter the number of credit hours you are looking for: "
    user_input = gets.to_i
    puts "\n\nSearch Results:"
    scraper.courseCatalog.each do |x|
        if x.minCH == user_input || x.maxCH == user_input
            print_values(x)
            count += 1
        end
    end
end

#total results found
if count == 1
    puts "There is 1 result that matches your search"
elsif count > 1
    puts "There are " + count.to_s + " results that match your search"
elsif count == 0
    puts "\nNo valid data could be found!\n"
end
>>>>>>> e9717fb838b1c781c88717baaccc928d287f60c8
