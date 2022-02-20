require_relative 'scraper2.rb'

puts "Welcome to the CSE course search!"
puts "You can search by course number, course name, description, instructor name, and course credit hours"
puts "Enter 1 for the course number (i.e. 'MATH2568')"
puts "Enter 2 for the course name (i.e. 'Linear Algebra')"
puts "Enter 3 to search for a word in the description (i.e. 'prerequisites')"
puts "Enter 4 to search for an instructors name"
puts "Enter 5 to search for course credit hours"

puts "\nPlease enter a field to search by: "
fieldName = gets.to_i

scraper = Scraper.new
totalPages = scraper.store_all_courses_page()

for i in 1..totalPages
    scraper.get_course_info(i)
end

if(fieldName == 1)
    puts "\nPlease enter what course number you would like to search for: "
    user_input = gets
    scraper.courseCatalog.each do |x|
        if user_input.chomp == x.subCat
            puts
            puts
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