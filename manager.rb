require_relative 'scraper.rb'
require 'mechanize'
require 'json'

class Manager

def manage
# Some example how to use it!
scraper = Scraper.new
continue = true
page_num = 1
while continue

continue = scraper.store_courses_page(page_num)
	if (page_num > 1 && continue)
	puts "Fetching page #{page_num}"
	puts "URL: #{@url}"
	end
if continue
	scraper.get_course_info(page_num)
	sleep(2)
	page_num = page_num + 1
end



#puts scraper.terms[0]   # Expected ==> Summer 2022
#puts scraper.title[0]   # Expected ==> Modeling and Problem Solving with Spreadsheets and Databases
#puts scraper.subject_catalogNumber[0]   # Expected ==> CSE2111
#scraper.pretty_print(1)
end



end
end
man = Manager.new
man.manage
