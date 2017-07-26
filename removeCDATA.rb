#!/usr/bin/env ruby

require 'mysql2' # to install : gem install mysql2

host = 'yourhost.fr'
username = 'forum'
password = 'yourpassword'
database = 'forum'

puts "This script removes CDATA from posts for PhpBB 3.2"
puts "Connecting..."

client = Mysql2::Client.new(:host => host,
                            :username => username,
                            :password => password,
                            :database => database)

puts "Querying, please wait..."
posts = client.query("select * from phpbb_posts")

posts.each do |p|
  content = p['post_text']
  r = /<!-- .+ -->/ # The regular expression to match CDATA (match HTML comments too)
  if r =~ content # regexp match
    puts "  MATCH: post_id=#{p['post_id']}"
    new_content = content.gsub(r,'') # remove the cdata from regular expression
    # puts new_content
    # escape the quotes if needed (not needed in my case)
    new_content = new_content.gsub("'","''")
    client.query("update phpbb_posts set post_text='#{new_content}' where post_id=#{p['post_id']}")
    puts "  #{p['post_id']} updated !"
  end
end
