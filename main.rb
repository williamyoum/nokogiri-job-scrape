# main.rb

require 'nokogiri'
require 'open-uri'
require 'pry'


def get_jobs
    date, role, url, company, array_of_jobs = '', '' ,'','', []

    base_url = 'http://www.garysguide.com'
    main_url = "#{base_url}/jobs?category=marketing&type=&region=newyork"
    data = data_scraper(main_url)
    # css data
    all_sections = data.css('
        table > tr > td > table > tr > td:nth-child(3) > table > tr')
    sections = all_sections.slice(2..all_sections.length)

    sections.each_with_index do |section, section_index|
        if section_index % 3 == 0 
            data = section.text
        elsif section_index % 3 == 1
            section.css('font').each_with_index do |job, job_index|
                if job_index % 3 == 0
                    role = job.text.strip
                    url = "#{base_url}#{job.at_css('a')['href']}"
                elsif job_index % 3 == 1
                    company = job.text.strip
                    array_of_jobs << {
                        date: date,
                        role: role,
                        url: url,
                        company: company
                    }
                end
            end
        end
    end
    array_of_jobs
end


def data_scraper(url)
    Nokogiri::HTML(open(url))
end


puts get_jobs