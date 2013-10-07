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

  def dm(target, message)
    @client.direct_message_create(target, message)
    puts "d #{target} Trying to send this direct message:"
    puts message
  end

  def everyones_last_tweet
    friends = @client.friends
    friends.sort_by! { |friend| friend.name.downcase }
    friends.each do |friend|
      last_tweet = friend.status.text
      timestamp  = friend.status.created_at
      # print each friend's screen_name
      print "#{friend.name} just said... "
      # print each friend's last message
      print last_tweet
      print " published #{timestamp.strftime('%A, %b %d')}"
      puts ""  # Just print a blank line to separate people
    end
  end



  def run
    command = ""
    while command != "q"
      puts ""
      printf "enter command: "
      input = gets.chomp
      parts = input.split
      command = parts[0]
      case command
        when 'q' then puts "Goodbye!"
        when 't' then tweet(parts[1..-1].join(" "))
        when 'dm' then dm(parts[1], parts[2..-1].join(" "))
        when 'elt' then everyones_last_tweet
         else
           puts "Sorry, I don't know how to (#{command})"
      end
    end
  end


end

blogger = MicroBlogger.new
blogger.run