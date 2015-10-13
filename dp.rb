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

if ARGV.length > 0
    file= ARGV.first

    f = File.open(file, "r")
    f.each_line { |line|
        # leaves the headlines
        if not line =~ /SYSN|\*|----|ORDER|\d{4}-\d{2}-\d{2}\s\d{2}.\d{2}.\d{2}/
            # read every line into string
            str = line
            str.length

            if line =~ /[a-zA-z]/
                # different order number
                if prevORN != str[10, 6]
                    # array is empty
                    if tempArray.length == 0
                        qty += 1
                        lineHash = {"ORN" => str[10,6], "TYPE" => str[18,4], "MOD" => str[24,3], "QTY" => qty, "DESC" => str[48,30].strip}
                        tempArray.push(lineHash)
                    else
                        ornArray.push(tempArray.last)
                        tempArray = []
                        qty = 1
                        lineHash = {"ORN" => str[10,6], "TYPE" => str[18,4], "MOD" => str[24,3], "QTY" => qty, "DESC" => str[48,30].strip}
                        tempArray.push(lineHash)
                    end
                    prevORN = str[10,6]
                #same order number
                else
                    if tempArray.length != 0
                        if prevFEAT == str[38,6]
                            qty += 1
                            lineHash = {"ORN" => str[10,6], "TYPE" => str[18,4], "MOD" => str[24,3], "QTY" => qty, "DESC" => str[48,30].strip}
                            tempArray.push(lineHash)
                            prevFEAT = str[38,6]
                        else
                            ornArray.push(tempArray.last)
                            tempArray = []
                            qty = 1
                            lineHash = {"ORN" => str[10,6], "TYPE" => str[18,4], "MOD" => str[24,3], "QTY" => qty, "DESC" => str[48,30].strip}
                            tempArray.push(lineHash)
                            prevFEAT = str[38,6]
                        end
                    end
                    prevORN = str[10,6]
                end
            end
        end
    }
    # don't forget the last line
    ornArray.push(tempArray.last)
else
    puts "You need files to proceed."
end

puts ornArray