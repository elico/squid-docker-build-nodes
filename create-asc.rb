#!/usr/bin/env ruby

require 'rubygems'			
require 'digest'

def calc(file)
 if File.exists?(file + ".asc")
 puts "signature file exits: overide it?(y/N)"
 over = $stdin.gets
  if over == nil
   puts "Cant interact with stdin aborting." 
   exit 1
  end
	if (over[0].downcase == "y")
	  puts "ok, writing new sig file."
	 else
	  puts "Aborting operation."
	  return
	 end
 end

date = File.ctime(file)

size = File.size(file)
sha1 = Digest::SHA1.new
sha256 = Digest::SHA256.new
md5  = Digest::MD5.new
sha2 =  Digest::SHA2.new
sha384 = Digest::SHA384.new
sha512 = Digest::SHA512.new
#tiger = Digest::Tiger.new

File.open(file) do|file|
  buffer = ''

  # Read the file 512 bytes at a time
  while not file.eof
    file.read(512, buffer)
    sha1.update(buffer)
    sha256.update(buffer)
    sha2.update(buffer)
    sha512.update(buffer)
    sha384.update(buffer)
    md5.update(buffer)
#    tiger.update(buffer)
  end
end

	File.open(file + ".asc", 'w') do|f| 
		f.puts "File: #{file}"
		f.puts "Date: #{date}" 
		f.puts "Size: #{size}"
		f.puts "MD5 : #{md5}"
		f.puts "SHA1: #{sha1}"
		f.puts "SHA2: #{sha2}"
		f.puts "SHA256: #{sha256}"
		f.puts "SHA384: #{sha384}"
		f.puts "SHA512: #{sha512}"
#		f.puts "TIGER: #{tiger}"
	end
end

def main
  if ARGV.size > 0 
	  if File.exists?(ARGV[0]) 
	   calc(ARGV[0])
	  else
	   puts "File: #{ARGV[0]} dosn't exist"
	  end
  else
	puts "missing file name or file dosnt exist"
  end
end

main

