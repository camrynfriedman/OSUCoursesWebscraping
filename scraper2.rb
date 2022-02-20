require 'mechanize'
require 'json'

class Scraper
	# An scraper object that has 
	attr_accessor :url, :courses, :terms, :title, :subject_catalogNumber

	# Created, immplemented, tested on 02/29/2022 by Yifan Zhou
	def initialize
		@url = "https://content.osu.edu/v2/classes/search"
        # An hashtable <<int>page_num: <hashTable>courses_data>, stores all the data about course
        @courses = {}
        
        # Collecting some useful information about courses
        @terms = []
        @title = []
        @subject_catalogNumber = []
        # menu_html = Nokogiri::HTML(menu['panels'][0]['html'])
        # course_content = json_data["data"]['courses'][0]["course"]["term"]
	end

    # Taking page_num as input, and store the result in courses
    def store_courses_page(page_num)
        agent = Mechanize.new       # Instantiate a Mechanize object
        html_data = agent.get(uri=@url, query={"q": "cse", "campus": "col_mrn_nwk_lma", "term": "1224", "p": page_num})
        # Parse to ruby interpretable data structure
        json_data = JSON.parse html_data.body
        # Save to courses instance
        @courses[page_num] = json_data["data"]['courses']
        course_content = json_data["data"]['courses'][0]["course"]["term"]
        puts "Course: #{course_content}"
    end

    # Taking page_num as input, and store the result in courses
    def store_all_courses_page()
        puts "===> Start scraping all courses info..."
        agent = Mechanize.new       # Instantiate a Mechanize object
        page_num = 1
        html_data = agent.get(uri=@url, query={"q": "cse", "campus": "col_mrn_nwk_lma", "term": "1224", "p": page_num})
        # rescue Mechanize::ResponseReadError => e
        json_data = JSON.parse html_data.body
        # Get total number of pages
        totalPages = json_data["data"]["totalPages"]
        puts "Total pages: #{totalPages}"
        # Store current page data
        @courses[page_num] = json_data["data"]['courses']
        # Test the result
        puts json_data["data"]['courses'][0]["course"]["term"]

        while json_data["data"]["nextPageLink"] != nil
            html_data = agent.get @url + json_data["data"]["nextPageLink"]
            json_data = JSON.parse html_data.body
            @courses[page_num] = json_data["data"]['courses']
            puts json_data["data"]['courses'][0]["course"]["term"]
        end

        File.write('./course-data.json', JSON.dump(@courses))
        puts "===> Finished scraping!"
    end

    # Collecting the useful information about each courses in page_num
    def get_course_info(page_num)
        @courses[page_num].each do |item| # for each things in things do something while storing that things in the variable item
            # print "#{item}"
            @terms << item["course"]["term"]
            @title << item["course"]["title"]
            @subject_catalogNumber << item["course"]["subject"] + item["course"]["catalogNumber"]
        end
    end

    def pretty_print(page_num)
		puts "A exaustive list of courses in #{page_num}!"
		@terms.each_with_index do |item, index|
			# puts name.class
			puts "#{index}; Course Term: #{item}; Course Number: #{@subject_catalogNumber[index]}; Course Title: #{@title[index]}"
		end
	end 

end

# Some example how to use it!
scraper = Scraper.new
scraper.store_all_courses_page()
# file = File.read('./course-data.json')
# scraper.courses = JSON.parse(file)
# scraper.store_courses_page(1)
# scraper.get_course_info(2)
# puts scraper.terms[0]   # Expected ==> Summer 2022
# puts scraper.title[0]   # Expected ==> Modeling and Problem Solving with Spreadsheets and Databases
# puts scraper.subject_catalogNumber[0]   # Expected ==> CSE2111
# scraper.pretty_print(2)

# File.write('./course-data.json', JSON.dump(data_hash))