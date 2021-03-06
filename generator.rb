#!/usr/bin/env ruby

# @title: Country and Subdivision SQL Generator
# @author: Andrew Horsman
# @description: Generates a list of all subvision names for each country.

# ./generator.rb file_to_convert.txt - make sure it exists.
unless File.exists? ARGV[0]
  puts "[-] File does not exist."
  exit
end

# Trims off newline characters and removes [subdivision] strings.
def trim(string)
  return string.gsub(/(\[.*?\]|\\|')/, "").chomp.chomp(" ")
end

countries = {} # Hash to store country => subdivisions[]

# Process input file.
File.open(ARGV[0]).each_line do |current_line|

  values = current_line.split(';').map { |i| trim(i) }
  next unless values.length == 2
  
  countries[values[0]] ||= []
  countries[values[0]] << values[1]

end

# Open an SQL File.
output = File.open("output.sql", "w")

# Create table and initial INSERT line.
output.puts <<eos
CREATE TABLE IF NOT EXISTS `countries_and_subdivisions` (
  `country_name` VARCHAR(255) NOT NULL,
  `country_subdivisions` TEXT NOT NULL
);

INSERT INTO `countries_and_subdivisions` (`country_name`, `country_subdivisions`) VALUES  
eos

# Insert all countries.
current_iteration = 1
final_iteration   = countries.length

countries.each do |country, subdivisions|
  # Comma separated list of subdivisions.
  output.puts "('#{country}', '#{subdivisions.join(',')}')" + ((current_iteration == final_iteration) ? ";" : ",")

  current_iteration += 1
end
