require_relative 'scraper2.rb'

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

courseNum, courseName, descriptor, instrName, creditHrs = nil, nil, nil, nil, nil
continue = true
while (continue)
#welcome message
puts "\nWelcome to the CSE course search!"
puts "You can search by course number, course name, description, instructor name, and course credit hours"
puts "Enter 1 for course number (i.e. 'MATH2568')"
puts "Enter 2 for course name (i.e. 'Linear Algebra')"
puts "Enter 3 for a word in the description (i.e. 'Prereq')" #can use the include? method for strings here if x.description.include? "prereq"
puts "Enter 4 for instructor"
puts "Enter 5 for course credit hours"
puts "Enter 6 to get the results"

print "\nPlease enter a field to search by or 6 for results: "
fieldName = gets.to_i

while !fieldName.between?(1,6)
    print "\nPlease enter a valid option: "
    fieldName = gets.to_i
end
if (fieldName == 1)
    print "\nPlease enter what course you would like to search for by providing the name and number with no spaces (i.e. MATH2568): "
    user_input = gets.upcase
elsif (fieldName == 2)
    print "\nPlease enter what course title you would like to search for (i.e. 'Linear Algebra'): "
    user_input = gets.chomp.upcase
elsif (fieldName == 3)
    print "\nPlease enter a keyword(s) from the course description (i.e. 'Prereq'): "
    user_input = gets.chomp.upcase
elsif (fieldName == 4)
    print "\nPlease enter the instructor's full name: "
    user_input = gets.chomp
elsif (fieldName == 5)
    print "\nPlease enter the number of credit hours you are looking for: "
    user_input = gets.to_i
elsif (fieldName == 6)
continue = false
end
end

if (courseNum != nil)
searchCourseNum(courseNum)
end
if (courseName != nil)
searchCourseName(courseName)
end
if (descriptor != nil)
searchDescription(descriptor)
end
if (instrName != nil)
searchInstructor(instrName)
end
if (creditHrs != nil)
searchCredit(creditHrs)
end

count = courseResults.length #to keep track of how many results show up after the search. also helpful for printing error message



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
