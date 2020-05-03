#!/usr/bin/ruby
# Simple validation for regex using egrep. Feel free to write something better.

require 'open3'

def validate_folder(folder)
  Dir.entries(folder).each do |regex|
    next if ['.', '..'].include?(regex)

    _stdout, stderr, _status = Open3.capture3("egrep -f #{folder}/#{regex} #{$PROGRAM_NAME}")

    if stderr.to_s == ''
      next
    end

    puts(stderr)
    puts(stderr)
    puts("Error in #{regex}")
    exit 2
  end
end

validate_folder('ignore.d.server'.chomp)
validate_folder('violations.ignore.d'.chomp)

# That's all folks
exit 0
