require_relative 'scraper2.rb'; nil

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
if(fieldName == 1)
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
elsif(fieldName == 2)
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
elsif(fieldName == 3)
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
    user_input = user_input.upcase
    puts "\n\nSearch Results:"
    scraper.courseCatalog.each do |x|
        ##CHANGE TO MAYBE JUST PRINT OUT THE SECTION THAT THE INSTRUCTOR IS TEACHING AND ITS INFO?
        #TODO - take into account that some professors have their entire name (i.e. Adam Russell Grupa) listed so if
        #someone tries to search "Adam Grupa" and finds nothing because they didn't type in "Adam Russell Grupa"
        #potential fix: tokenize the user input and search through all the instructors using the tokens? anno
        if x.teachers.map(&:upcase).include? (user_input)
            print_values(x)
            count += 1
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
