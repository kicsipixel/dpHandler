#!/usr/bin/env ruby
#  
#   dp.rb
#   dpHandleer v0.1
# 	Handling a strange file from admin to verify the order load
#
#   Created by Toth, Szabolcs on October 11, 2015
#   Special thanks to Visegrady, Tamas - "If it was hard to write, it should be hard to read"

# Global variables
ornArray = Array.new
tempArray = Array.new
lineHash = Hash.new
prevORN = ""
# prevTYPE = ""
prevFEAT = ""
qty = 0

if ARGV.length > 1
    file= ARGV.first

    f = File.open(file, "r")
    f.each_line { |line|
        # leaves the headlines
        if not line =~ /SYSN|\*|----|ORDER|\d{4}-\d{2}-\d{2}\s\d{2}.\d{2}.\d{2}/
            # read every line into string
            str = line
            str.length
            # TODO need to put as regexp above
           if line =~ /[a-zA-Z]/
           		if prevORN != str[10, 6]
            	   if tempArray.length == 0
                        qty += 1
                        lineHash = {"ORN" => str[10,6], "TYPE" => str[18,4], "MOD" => str[24,3], "QTY" => qty, "DESC" => str[48,30]}
                        tempArray.push(lineHash)
                        prevORN = str[10,6]
            	   end
                else
                    if tempArray.length != 0
                        if prevFEAT != str[28,6]
                            ornArray.push(tempArray.last)
                            tempArray = []
                            qty = 1
                            lineHash = {"ORN" => str[10,6], "TYPE" => str[18,4], "MOD" => str[24,3], "QTY" => qty, "DESC" => str[48,30]}
                            tempArray.push(lineHash)
                        else
                            qty += 1
                            lineHash = {"ORN" => str[10,6], "TYPE" => str[18,4], "MOD" => str[24,3], "QTY" => qty, "DESC" => str[48,30]}
                            tempArray.push(lineHash)
                        end
                    end
            	end
            end
        end
    }
    f.close
else
    puts "You need files to proceed."
end

=begin
z = ARGV.length
puts z
puts "first: #{ARGV.first}"
for i in 1..ARGV.length-1
    puts "#{i+1}. : #{ARGV[i]}"
end  
=end