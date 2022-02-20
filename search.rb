require_relative 'scraper2.rb'

puts "Welcome to the CSE course search!"
puts "You can search by course number, course name, description, prerequisites, instructor name, and course credit hours"
#maybe put an example of what each of these would be, i think there is some ambiguity
puts "\nPlease enter a field to search by: "
fieldName = gets
puts "\nPlease enter what you would like to search in " + fieldName
user_input = gets

scraper = Scraper.new
totalPages = scraper.store_all_courses_page()

for i in 1..totalPages
    scraper.get_course_info(i)
end

#this doesn't work idk why probably something dumb

if(fieldName.chomp == "course name")
    scraper.courseCatalog.each do |x|
        if user_input.chomp == x.subCat #need to fix this condition
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