# Country and Subdivision SQL Generator

# @author: Andrew Horsman
# @description: Generates a list of all subvision names for each country.

# ./generator.rb file_to_convert.txt - make sure it exists.
unless File.exists? ARGV[0]
  puts "[-] File does not exist."
  exit
end

countries = {} # Hash to store country => subdivisions[]

File.open(ARGV[0]).each_line do |current_line|

  values = current_line.split(';')
  next unless values.length == 2
  
  countries[values[0]] == [] unless countries.includes? values[0] 
  countries[values[0]] << values[1]

end

print countries
