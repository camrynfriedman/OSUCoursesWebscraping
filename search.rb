require_relative 'scraper2.rb'; nil

puts "Welcome to the CSE course search!"
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

scraper = Scraper.new
totalPages = scraper.store_all_courses_page()

for i in 1..totalPages
    scraper.get_course_info(i)
end

if(fieldName == 1)
    puts "\nPlease enter what course you would like to search for by providing the name and number with no spaces (i.e. MATH2568): "
    user_input = gets.upcase!
    scraper.courseCatalog.each do |x|
        if user_input.chomp== x.subCat
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
elsif(fieldName == 2)
    puts "\nPlease enter what course title you would like to search for (i.e. 'Linear Algebra'): "
    user_input = gets.upcase
    scraper.courseCatalog.each do |x|
        if user_input.chomp == x.title.upcase
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
elsif(fieldName == 3)
    puts "\nPlease enter what a keyword from the course description (i.e. 'Prereq'): "
    user_input = gets.chomp.upcase
    scraper.courseCatalog.each do |x|
        unless x.description.nil?
            if x.description.upcase.include?(user_input)
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
elsif(fieldName == 4)
    puts "\nPlease enter the instructor's full name: "
    user_input = gets.upcase
    scraper.courseCatalog.each do |x|
        ##CHANGE TO MAYBE JUST PRINT OUT THE SECTION THAT THE INSTRUCTOR IS TEACHING AND ITS INFO?
        #TODO - take into account that some professors have their entire name (i.e. Adam Russell Grupa) listed so if
        #someone tries to search "Adam Grupa" and finds nothing because they didn't type in "Adam Russell Grupa"
        #potential fix: tokenize the user input and search through all the instructors using the tokens? anno
        if x.teachers.map(&:upcase).include? (user_input.chomp)
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
else
    puts "No valid data could be found!"
end


#if statements for each field (i.e. if fieldName == "course name") then search the array of objects to see if user_input == object.title and print those out
#should do error checking for user input too