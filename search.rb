require_relative 'scraper.rb'

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
        puts "Enter 1 for basic search (one attribute)"
        puts "Enter 2 for advanced search (multiple attributes)"
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
        while (!fieldName.between?(1,5))
            puts "\nError: Input out of acceptable range"
            print "Please make a selection: "
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
            i=0
            while i<x.teachers.length
                name = x.teachers[i].upcase.split
                if name[0] == tokenized_user_input[0] and name[name.length-1] == tokenized_user_input[tokenized_user_input.length-1]
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
        answer = @scraper.courseCatalog
        continue = true
        while (continue)
            puts "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            puts "Please enter a field value you would like to use to narrow down your search results"
            puts "1: Course Title"
            puts "2: Description"
            puts "3: Instructor Name"
            puts "4: Credit Hours"
            puts "5: Display Courses Meeting Selected Criteria"
            puts "6: Reset criteria selections"
            puts "7: Quit"
            puts
            countResults(answer.length)
            puts
            print "Please make a selection: "

            newField = gets.to_i
            while newField < 1 or newField > 7
                puts "\nError: Input out of acceptable range"
                print "Please make a selection: "
                newField = gets.to_i
            end

            #NOTE: For advanced search, since there is no value to searching for a specific class code (ex. MATH2568).
            #This is because it would simply be cut down to a singular class, being the one that was chosen.
            #Thus, for searches like that, the user would use a basic search, so advanced search doesn't include it.

            if(newField == 1)
                arr = []
                print "\nPlease enter what course title you would like to search for (i.e. 'Linear Algebra'): "
                user_input = gets.chomp
                user_input = user_input.upcase
                
                answer.each do |x|
                    if !x.title.upcase.include?(user_input) 
                        arr << x #adding x to an array
                    end
                end
                answer = (answer - arr)
            end
            
            if(newField == 2)
                arr = []
                print "\nPlease enter a keyword(s) from the course description (i.e. 'Prereq'): "
                user_input = gets.chomp
                user_input = user_input.upcase
                
                answer.each do |x|
                    unless x.description.nil?
                        if !x.description.upcase.include?(user_input)
                            arr << x #adding x to an array
                        end
                    end
                    if x.description.nil?
                        arr << x
                    end
                end
                answer = (answer - arr)
            end
            
            if(newField == 3)
                arr = []
                print "\nPlease enter the instructor's FULL name: "
                user_input = gets.chomp
                #tokenize and capitalize user input
                tokenized_user_input = user_input.upcase.split

                answer.each do |x|
                    i = 0
                    count = 0
                    while i<x.teachers.length
                        name = x.teachers[i].upcase.split
                        
                        #incrementing count if it exists in the array of teachers for the x course object
                        if name[0] == tokenized_user_input[0] and name[name.length-1] == tokenized_user_input[tokenized_user_input.length-1]
                        #if x.teachers[i].include?(user_input)
                            count += 1
                        end

                        i+=1
                    end

                    #if the count is still 0 arr gets added
                    if count == 0
                        arr<<x
                    end
                end

                #removes the array from the course catalog
                answer = (answer - arr)
                
            end
            
            if(newField == 4)
                arr = []
                print "\nPlease enter the number of credit hours you are looking for: "
                user_input = gets.to_i
                
                answer.each do |x|
                    if x.minCH != user_input and x.maxCH != user_input
                        arr << x
                    end
                end
                answer = (answer - arr)
                
            end

            if(newField == 5)
                puts "\n\nSearch Results:"
                #print values of array
                answer.each do |y|
                    print_values(y)
                end
            end

            if(newField == 6)
                answer = @scraper.courseCatalog
            end

            if(newField == 7)
                continue = false
            end
        end
    end

    #total results found
    def countResults(count)
        if count == 1
            puts "There is 1 course that meets selected criteria"
        elsif count > 1
            puts "There are " + count.to_s + " courses that meet selected criteria"
        elsif count == 0
            puts "There are no courses that meet selected criteria. You can reset (6) to undo all selections"
        end
    end

end

search = Search.new
search.initScraper
search.welcoming
