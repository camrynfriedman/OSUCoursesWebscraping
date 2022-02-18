require 'mechanize'
require 'json'

class Test

def extract


 agent = Mechanize.new do |a|
 a.user_agent_alias = "Mac Safari"
 end
 page = agent.get "https://classes.osu.edu/class-search/#/?q=CSE&campus=col&term=1224&p=1&subject=cse"
puts page.uri
sleep(2)
puts "fetching page 2"



puts page.uri
sleep(2)
puts "fetching page 3" 

end

end

x = Test.new
x.extract
