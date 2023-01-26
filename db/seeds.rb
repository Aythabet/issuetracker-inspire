# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
require 'securerandom'
require 'csv'
require 'net/http'
require 'uri'
require 'faker'

Issue.destroy_all
Project.destroy_all
Owner.destroy_all
Departement.destroy_all

p('Database dropped...')

Departement.create([{
                      'name': 'Backend'
                    },
                    {
                      'name': 'Frontend'
                    },
                    {
                      'name': 'Project Management'
                    },
                    {
                      'name': 'DevOps'
                    },
                    {
                      'name': 'Design'
                    },
                    {
                      'name': 'Rédaction'
                    }
                    ]);

p('Departements seeded...')

CSV.foreach('db/jira_users.csv') do |row|
  User.create([
                {
                  'id': row[0],
                  'email': row[2],
                  'password': 'azertyu',
                  'password_confirmation': 'azertyu',
                  'admin': false
                }
  ])
end
CSV.foreach('db/jira_users.csv') do |row|
  Owner.create([
                 {
                   'departement': Departement.all.sample.name,
                   'user_id': row[0],
                   'name': row[1],
                   'status': row[3],
                   'date_joined_jira':  row[4],
                   'last_seen_on_jira': row[5]
                 }
  ])
end
p('== Rubies Merchant account created...')
User.update(email: "admin@inspiregroup.io", admin: true)
p('== Admin previlege assigned... ')

# Import Projects from Jira and seeds the DB with their values
@collected_projects = []

def collect_projects(output_array)
  i = 0
  while i < output_array['values'].length
    project_key = output_array['values'][i]['key']
    project_name = output_array['values'][i]['name']
    project_lead = output_array['values'][i]['lead']['displayName']
    @collected_projects << [project_key, project_name, project_lead]
    i += 1
  end
end

def get_projects(start)
  url = URI.parse("https://agenceinspire.atlassian.net/rest/api/3/project/search?startAt=#{start}&maxResults=50&expand=lead")
  headers = {
    'Authorization' =>  "Basic #{ENV['JIRA_API_TOKEN']}",
    'Content-Type' => 'application/json'
  }

  request = Net::HTTP::Get.new(url, headers)

  response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
    http.request(request)
  end

  response_output_issues = JSON.parse(response.body)
  collect_projects(response_output_issues)
end

get_projects(0)
get_projects(50)

@collected_projects.each do |project|
  Project.create([{'name': project[1], 'jiraid': project[0], 'lead': project[2]}])
end

p('°° Projects listed....')


# Collect Projects in data base for issues generation // Delete this when starting the official issues
projects_array = []
Project.all.each do |project|
  projects_array << [project[:jiraid] , project[:id]]
end

p('°° Projects table generated...')

projects_array.each do |key, id|
  10.times do
    Issue.create(
      jiraid: "#{key}-#{SecureRandom.random_number(50)}",
      project: Project.find_by(id:),
      owner: Owner.all.sample,
      departement: Departement.all.sample.name,
      time_real: rand(1..20),
      time_forecast: rand(1..20),
      status: ['In Progress', 'On Hold', 'Done', 'Archived'].sample
    )
  end
end

p('~~ Issues seeded!')

100.times do
  Dailyreport.create(
    comment: Faker::Fantasy::Tolkien.poem ,
    owner: Owner.all.sample,
    issues: Issue.limit(3).order("RANDOM()")
  )
end
p('~~ You wish you get your #CR generated like this....')

output = "< Database seeded with success! >\n-------\n    \\   ^__^\n     \\  (oo)\\_______\n        (__)\\       )\\/\n            ||----w |\n            ||     ||"
puts output
