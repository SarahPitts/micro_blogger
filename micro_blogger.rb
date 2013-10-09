require 'jumpstart_auth'
require 'bitly'

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

  def shorten_url(original_url)
    unless original_url.nil?
      puts "Shortening this URL: #{original_url}"
      @bitly ||= bitly_auth
      @bitly.shorten(original_url).short_url
    else
      puts "ERROR: Need to provide a URL."
    end
  end

  def bitly_auth
    Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
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
        when "s" then puts shorten_url(parts[1])
        when "turl" then tweet(parts[1..-2].join(" ") + " " + shorten_url(parts[-1]))
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