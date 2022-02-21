require_relative 'scraper2.rb'



class Search
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

def options_menu
    puts "Enter 1 for course number (i.e. 'MATH2568')"
    puts "Enter 2 for course name (i.e. 'Linear Algebra')"
    puts "Enter 3 for a word in the description (i.e. 'Prereq')"
    puts "Enter 4 for instructor"
    puts "Enter 5 for course credit hours"
end


#initializing scraper
def initScraper
@scraper = Scraper.new
totalPages = @scraper.store_all_courses_page()

for i in 1..totalPages
    @scraper.get_course_info(i)
end
end

def welcoming
#welcome message
puts "\nWelcome to the CSE course search!"
puts "You can search by course number, course name, description, instructor name, and course credit hours"
puts "Enter 1 for basic search (one attribute)"
puts "Enter 2 for advanced search (more than one filter)"
print "Enter an option: "
search_field = gets.to_i
while (search_field != 1 && search_field != 2)
puts "You have entered an invalid option!"
print "Enter a valid option (1 or 2): "
search_field = gets.to_i
end

if (search_field == 1)
basicSearch
else
advancedSearch
end
end
#----------------BASIC SEARCH--------------
def basicSearch
    puts "\n"
    options_menu
    print "Enter an option: "
    fieldName = gets.to_i
   while (fieldName != 1 && fieldName != 2 && fieldName != 3 && fieldName != 4 && fieldName != 5)
    print "\nPlease enter a valid option (1-5): "
    fieldName = gets.to_i
    end
    #course number
    if fieldName == 1
   	courseNumBasic
    #course name
    elsif fieldName == 2
    	courseNameBasic
    #description
    elsif fieldName == 3
    	descriptionBasic
    #instructor
    elsif(fieldName == 4)
   	instrNameBasic
    #credit hours
    elsif(fieldName == 5)
	creditBasic
    end
end


def courseNumBasic
count = 0
        print "\nPlease enter what course you would like to search for by providing the name and number with no spaces (i.e. MATH2568): "
        user_input = gets
        user_input = user_input.upcase
        puts "\n\nSearch Results:"
        @scraper.courseCatalog.each do |x|
            if user_input.chomp == x.subCat
                print_values(x)
                count += 1

            end
        end
        countResults(count)
end

def courseNameBasic
count = 0
        print "\nPlease enter what course title you would like to search for (i.e. 'Linear Algebra'): "
        user_input = gets.chomp
        user_input = user_input.upcase
        puts "\n\nSearch Results:"
        @scraper.courseCatalog.each do |x|
            if x.title.upcase.include?(user_input) #if user types "software" all classes with that word will show up in results
                print_values(x)
                count += 1
            end
        end
        countResults(count)
end

def descriptionBasic
count = 0
print "\nPlease enter a keyword(s) from the course description (i.e. 'Prereq'): "
        user_input = gets.chomp
        user_input = user_input.upcase
        puts "\n\nSearch Results:"
        @scraper.courseCatalog.each do |x|
            unless x.description.nil?
                if x.description.upcase.include?(user_input)
                    print_values(x)
                    count += 1
                end
            end
        end

	countResults(count)
end

def instrNameBasic
count = 0
 print "\nPlease enter the instructor's full name: "
        user_input = gets.chomp
        #tokenize and capitalize user input
        tokenized_user_input = user_input.upcase.split
        puts "\n\nSearch Results:"
        @scraper.courseCatalog.each do |x|
            #TODO - take into account that some professors have their entire name (i.e. Adam Russell Grupa) listed so if
            #someone tries to search "Adam Grupa" and finds nothing because they didn't type in "Adam Russell Grupa"
            #teachers_uppercase = x.teachers.map(&:upcase)
            i=0
            while i<x.teachers.length
                name = x.teachers[i].upcase.split
                if !name.include? (tokenized_user_input[0] and tokenized_user_input[tokenized_user_input.length-1])
                    print_values(x)
                    count+=1
                end
                i+=1
            end

        end
        
        countResults(count)
end

def creditBasic
count = 0
        print "\nPlease enter the number of credit hours you are looking for: "
        user_input = gets.to_i
        puts "\n\nSearch Results:"
        @scraper.courseCatalog.each do |x|
            if x.minCH == user_input || x.maxCH == user_input
                print_values(x)
                count += 1
            end
        end
	countResults(count)
end


#-------------ADVANCED SEARCH-------------
def advancedSearch
    courseNum, courseName, descriptor, instrName, creditHrs = nil, nil, nil, nil, nil
    @answer = @scraper.courseCatalog
continue = true
while (continue)
puts "\n"
options_menu

print "\nPlease enter a field to search by or type 'exit' for results: "
fieldName = gets.chomp

while (fieldName != "1" && fieldName != "2" && fieldName != "3" && fieldName != "4" && fieldName != "5" && fieldName != "exit")
    print "\nPlease enter a valid option (1-5 or exit): "
    fieldName = gets.chomp
end
if (fieldName == "1")
    print "\nPlease enter what course you would like to search for by providing the name and number with no spaces (i.e. MATH2568): "
    courseNum = gets.chomp.upcase
elsif (fieldName == "2")
    print "\nPlease enter what course title you would like to search for (i.e. 'Linear Algebra'): "
    courseName = gets.chomp.upcase
elsif (fieldName == "3")
    print "\nPlease enter a keyword(s) from the course description (i.e. 'Prereq'): "
    descriptor = gets.chomp.upcase
elsif (fieldName == "4")
    print "\nPlease enter the instructor's full name: "
    instrName = gets.chomp
elsif (fieldName == "5")
    print "\nPlease enter the number of credit hours you are looking for: "
    creditHrs = gets.to_i
elsif (fieldName == "exit")
continue = false
end

end

if (courseNum != nil)
        arr = []       
        @answer.each do |x| #x is a course object
            #we want to remove all the instances where they DON'T match
            from the course catalog
            if courseNum.chomp != x.subCat 
                arr << x #adding x to an array
            end
        end
         @answer = (@answer - arr)   

end
if (courseName != nil)
       arr = []
       @answer.each do |x|
           if !x.title.upcase.include?(courseName) 
               arr << x #adding x to an array
         end
        end
        @answer = (@answer - arr)   
end
if (descriptor != nil)
       arr = []
       @answer.each do |x|
           unless x.description.nil?
                if !x.description.upcase.include?(descriptor)
                    arr << x #adding x to an array
                end
            end
            if x.description.nil?
                arr << x
            end
        end
        @answer = (@answer - arr)       

end
if (instrName != nil)

        arr = []
  #tokenize and capitalize user input
        tokenized_user_input = instrName.upcase.split

        @answer.each do |x|
          i=0
            while i<x.teachers.length
                name = x.teachers[i].upcase.split
                if name.include? (tokenized_user_input[0] and tokenized_user_input[tokenized_user_input.length-1])
                    arr << x
                end
              i+=1
            end
        end
        @answer = (@answer - arr)   
end
if (creditHrs != nil)

        arr = []
     	@answer.each do |x|
            if x.minCH != creditHrs and x.maxCH != creditHrs
                arr << x
            end
        end
          @answer = (@answer - arr) 

end
puts "Results:\n"
   @answer.each do |x|
       print_values(x)
   end

    count = @answer.length #to keep track of how many results show up after the search. also helpful for printing error message
    #AISHWARYA's code
    countResults(count)
end

def searchCourseNum(courseNum)
        arr = []       
        @answer.each do |x| #x is a course object
            #we want to remove all the instances where they DON'T match
            #from the course catalog
            if courseNum.chomp != x.subCat 
                arr << x #adding x to an array
            end
        end
        @answer = (@answer - arr)

end

def searchCourseName(courseName)
       arr = []
       @scraper.courseCatalog.each do |x|
            if !x.title.upcase.include?(courseName) 
                arr << x #adding x to an array
            end
        end
        @answer = (@answer - arr)
end

def searchDescription(descriptor)
       arr = []
       @scraper.courseCatalog.each do |x|
            unless x.description.nil?
                if !x.description.upcase.include?(descriptor)
                    arr << x #adding x to an array
                end
            end
            if x.description.nil?
                arr << x
            end
        end
        @answer = (@answer - arr)       

end

def searchInstructor(instrName)
        arr = []
  #tokenize and capitalize user input
        tokenized_user_input = instrName.upcase.split
        i=0
        @scraper.courseCatalog.each do |x|
            while i<x.teachers.length
                name = x.teachers[i].upcase.split
                if name.include? (tokenized_user_input[0] and tokenized_user_input[tokenized_user_input.length-1])
                    arr << x
                end
              i+=1
            end
        end
        
        @answer = (@answer - arr)
       
end

def searchCredit(creditHrs)
        arr = []
     	@scraper.courseCatalog.each do |x|
            if x.minCH != creditHrs and x.maxCH != creditHrs
                arr << x
            end
        end
        @answer = (@answer - arr)

end





#total results found
def countResults(count)
if count == 1
    puts "There is 1 result that matches your search"
elsif count > 1
    puts "There are " + count.to_s + " results that match your search"
elsif count == 0
    puts "\nNo valid data could be found!\n"
end

end

end

search = Search.new
search.initScraper
search.welcoming

