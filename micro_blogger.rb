require 'jumpstart_auth'

class MicroBlogger
  attr_reader :client

  def initialize
    puts "Initializing"
    @client = JumpstartAuth.twitter
  end

  def tweet(message)
  	if message.length <= 140
		@client.update(message)
   	else
   		puts "Must be 140 characters or less"
  	end
  end
end

blogger = MicroBlogger.new
blogger.tweet("MicroBlogger 140 test")