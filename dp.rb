#!/usr/bin/env ruby
#  
#   dp.rb
#   dpHandleer v0.1
# 	Handling a strange file from admin to verify the order load
#
#   Created by Toth, Szabolcs on October 11, 2015
#   Special thanks to Visegrady, Tamas - "If it was hard to write, it should be hard to read"

#XML parsing
require 'Nokogiri'

# Global variables
ornArray = Array.new
configArray = Array.new
tempArray = Array.new
lineHash = Hash.new
prevORN = ""
prevFEAT = ""
prevType = ""
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

            if line =~ /[a-zA-z]/
                # different order number
                if prevORN != str[10, 6]
                    # array is empty
                    if tempArray.length == 0
                        qty += 1
                        if str[38,6].strip != "" 
                                lineHash = {"ORN" => str[10,6], "TYPE" => str[18,4], "MOD" => str[38,6].strip, "QTY" => qty.to_s, "DESC" => str[48,30].strip}
                            else
                                lineHash = {"ORN" => str[10,6], "TYPE" => str[18,4], "MOD" => str[24,3].strip, "QTY" => qty.to_s, "DESC" => str[48,30].strip}
                            end
                        tempArray.push(lineHash)
                    else
                        ornArray.push(tempArray.last)
                        tempArray = []
                        qty = 1
                        if str[38,6].strip != ""
                                lineHash = {"ORN" => str[10,6], "TYPE" => str[18,4], "MOD" => str[38,6].strip, "QTY" => qty.to_s, "DESC" => str[48,30].strip}
                            else
                                lineHash = {"ORN" => str[10,6], "TYPE" => str[18,4], "MOD" => str[24,3].strip, "QTY" => qty.to_s, "DESC" => str[48,30].strip}
                            end
                        tempArray.push(lineHash)
                    end
                    prevORN = str[10,6]
                
                #same order number
                else
                    if tempArray.length != 0
                        if prevFEAT == str[38,6]
                            qty += 1
                            if str[38,6].strip != ""
                                lineHash = {"ORN" => str[10,6], "TYPE" => str[18,4], "MOD" => str[38,6].strip, "QTY" => qty.to_s, "DESC" => str[48,30].strip}
                            else
                                lineHash = {"ORN" => str[10,6], "TYPE" => str[18,4], "MOD" => str[24,3].strip, "QTY" => qty.to_s, "DESC" => str[48,30].strip}
                            end
                            tempArray.push(lineHash)
                            prevFEAT = str[38,6]
                        else
                            ornArray.push(tempArray.last)
                            tempArray = []
                            qty = 1
                            if str[38,6].strip != ""
                                lineHash = {"ORN" => str[10,6], "TYPE" => str[18,4], "MOD" => str[38,6].strip, "QTY" => qty.to_s, "DESC" => str[48,30].strip}
                            else
                                lineHash = {"ORN" => str[10,6], "TYPE" => str[18,4], "MOD" => str[24,3].strip, "QTY" => qty.to_s, "DESC" => str[48,30].strip}
                            end
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
    if tempArray.last != nil
        ornArray.push(tempArray.last)
    end
    f.close

    filename = ARGV[1]

    if (filename)
            f = File.open(filename)
            doc = Nokogiri::XML(f)

            doc.xpath('//ProductLineItem | //ProductSubLineItem').each do |y|
                id = y.at('ProprietaryProductIdentifier').text
                qty = y.at('Quantity').text
                desc = y.at('ProductDescription').text
                category = y.at('ProductTypeCode').text
                if y.at('ProprietaryProductIdentifier') != nil
                    if y.at('ProductLineNumber') != nil
                        type = y.at('ProprietaryProductIdentifier').text
                    end
                end

              if category == "Hardware" || category == "Software"
                lineHash = ""
            
                if type != nil
                    if id.length > 4
                        id = id.gsub(/\A\S{4}-/,'').strip
                    end

                    lineHash = {"TYPE" => type.gsub(/-\S{3}\z/,'').strip, "MOD" => id, "QTY" => qty, "DESC" => desc}
                    configArray.push(lineHash)
                    prevType = type
                else
                     if id.length > 4
                        id = id.gsub(/\A\S{4}-/,'').strip
                    end

                    type = prevType
                    lineHash = {"TYPE" => type.gsub(/-\S{3}\z/,'').strip, "MOD" => id, "QTY" => qty, "DESC" => desc}
                    configArray.push(lineHash)
                end
              end
            end
        f.close
    else
        puts "You need an input XML file!"
    end
else
    puts "You need files to proceed."
end
    

configArray.delete_if do |y|
    ornArray.delete_if do |x|
        if x["MOD"] == y["MOD"] && x["QTY"] == y["QTY"]
            true
       end  
    end
end

# What we have as remaining...
puts ornArray
