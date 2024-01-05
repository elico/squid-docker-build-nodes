#!/usr/bin/env ruby

require 'nokogiri'
require "httparty"

versions_url = "http://www.squid-cache.org/Versions/"

response = HTTParty.get(versions_url)
html = response.body

doc = Nokogiri::HTML(html)

tables = doc.search('table')

current_version = tables[0]

current_version_path = current_version.css('tr > td')[0].css('a[href]').first['href']
version_page_url = "#{versions_url}#{current_version_path}"

response = HTTParty.get(version_page_url)
html = response.body

doc = Nokogiri::HTML(html)

tables = doc.search('table')

current_version = tables[0]

latest_release_files = []

latest_release = current_version.css('tr > td')[3].css('a[href]').each do |h|
	latest_release_files << "#{version_page_url}#{h['href']}"
end

latest_release_files.each do |l|
	puts l if l.end_with?(".xz")
end
