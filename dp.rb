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
lineHash = Hash.new
prevORN = ""
prevTYPE = ""
prevFEAT = ""
qty = 0

 while (line = gets)
    # leaves the headlines
    if not line =~ /SYSN|\*|----|ORDER|\d{4}-\d{2}-\d{2}\s\d{2}.\d{2}.\d{2}/
        # read every line into string
        str = line
        str.length
        # TODO need to put as regexp above
       if line =~ /[a-zA-Z]/
       		if prevORN != str[10, 6]
        		puts "\n"
        		puts str[10, 6]
        		puts "------"

        		if ornArray.length == 0
        			qty += 1
        			lineHash = {"ORN" => str[10,6], "TYPE" => str[18,4], "MOD" => str[24,3], "DESC" => str[48,30]}
        			ornArray.push(linesHash)
        		end
        		
        	end
        end
    end
end

=begin
if prevTYPE != str[18,4]
        			if qty != 0
	        			print "#{str[18,4]}\t#{str[24,3]}\t#{qty}\n"
	        			prevTYPE = str[18,4]
	        		end
        		else
        			print "#{str[18,4]}\t#{str[24,3]}\n"
        			prevTYPE = str[18,4]
        			qty = qty + 1
        		end

        		prevORN = str[10,6]
        	else
        		if prevTYPE != str[18,4]
        			print "#{str[18,4]}\t#{str[24,3]}\n"
        			prevTYPE = str[18,4]
        		else
        			print "#{str[18,4]}\t#{str[24,3]}\n"
        			prevTYPE = str[18,4]
        		end
=end