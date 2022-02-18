require 'mechanize'
require 'json'

class Scraper
	# An scraper object that has 
	attr_accessor :url, :json_data, :courses, :terms, :title, :subject_catalogNumber

	# Created, immplemented, tested on 06/09/2019 by Yifan Zhou
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
        if (html_data != nil)
     
        # Parse to ruby interpretable data structure
        @json_data = JSON.parse html_data.body
          puts "#{json_data}"
        # Save to courses instance
        @courses[page_num] = json_data["data"]['courses']
        else
        continue = false
        end
        
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


