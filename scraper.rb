require 'mechanize'
require 'json'

class Course
    attr_reader :title, :subCat, :description, :teachers, :maxCH, :minCH
    def initialize(title, subCat, description, teachers, maxCH, minCH)
        @title = title
        @subCat = subCat
        @description = description
        @teachers = teachers
        @maxCH = maxCH
        @minCH = minCH
    end
end

class Scraper
	attr_accessor :url, :coursePages, :courseCatalog

	# Created, immplemented, tested on 02/19/2022 by Yifan Zhou
	def initialize
		@url = "https://content.osu.edu/v2/classes/search"
        @initial_query = "?q=cse&campus=col&term=1224&p=1"
        # An hashtable <<int>page_num: <hashTable>courses_data>, stores all the data about course
        @coursePages = {}

        @courseCatalog = []
	end

    # Taking page_num as input, and store the result in courses
    def store_all_courses_page()
        puts "===> Start scraping all courses info..."
        page_num = 1
        agent = Mechanize.new       # Instantiate a Mechanize object
        puts "Initial page request: " + @url + @initial_query
        html_data = agent.get(@url + @initial_query)
        
        json_data = JSON.parse html_data.body
        # Get total number of pages
        totalPages = json_data["data"]["totalPages"]
        # Store current page data
        @coursePages[page_num] = json_data["data"]['courses']
        get_course_info(page_num)

        while json_data["data"]["nextPageLink"] != nil
            page_num += 1
            sleep(2)
            puts "Getting Page #{page_num}: " + @url + json_data["data"]["nextPageLink"]
            html_data = agent.get(@url + json_data["data"]["nextPageLink"])
            json_data = JSON.parse html_data.body
            @coursePages[page_num] = json_data["data"]['courses']
            get_course_info(page_num)
        end

        puts "===> Finished scraping!"
        puts "===> Total pages: #{totalPages}"
        return totalPages
    end

    # Collecting the useful information about each courses in page_num
    def get_course_info(page_num)
        @coursePages[page_num].each do |item| # for each things in things do something while storing that things in the variable item
            # print "#{item}"
            newTitle = item["course"]["title"]
            newSubCat = item["course"]["subject"] + item["course"]["catalogNumber"]
            newDesc = item["course"]["description"]
            newTeachArray = []
            newMaxCH = item["course"]["maxUnits"]
            newMinCH = item["course"]["minUnits"]
            item["sections"].each do |section|
                if !(newTeachArray.include? section["meetings"][0]["instructors"][0]["displayName"]) && (section["meetings"][0]["instructors"][0]["displayName"] != nil)
                    newTeachArray << section["meetings"][0]["instructors"][0]["displayName"]
                end
            end 
            courseDoesntExist = true
            @courseCatalog.each do |existing|
                if courseDoesntExist && existing.subCat == newSubCat
                    courseDoesntExist = false
                    newTeachArray.each do |newT|
                        teachDoesntExist = true
                        existing.teachers.each do |oldT|
                            if teachDoesntExist && oldT == newT
                                teachDoesntExist = false
                            end
                        end
                        if teachDoesntExist
                            existing.teachers << newT
                        end
                    end
                end
            end
            if courseDoesntExist
                @courseCatalog << Course.new(newTitle, newSubCat, newDesc, newTeachArray, newMaxCH, newMinCH)
            end
        end
    end
end
