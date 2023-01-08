# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
require 'securerandom'
require "csv"
require 'net/http'
require 'uri'

Issue.destroy_all
Project.destroy_all
Owner.destroy_all
Departement.destroy_all

p("Database dropped...")

departement = Departement.create([{
                                    "name": "Backend"
                                  },
                                  {
                                    "name": "Frontend"
                                  },
                                  {
                                    "name": "Project Management"
                                  },
                                  {
                                    "name": "DevOps"
                                  },
                                  {
                                    "name": "Design"
                                  },
                                  {
                                    "name": "Rédaction"
                                  }
                                  ]);

p("Departement seeded!")

CSV.foreach("db/jira_users.csv") do |row|
  owner = Owner.create([
                         {
                           "departement": Departement.all.sample.name,
                           "jiraid": row[0],
                           "name": row[1],
                           "email": row[2],
                           "status": row[3],
                           "date_joined_jira":  row[4],
                           "last_seen_on_jira": row[6]
                         }
  ]);
end

p("JIRA Users imported seeded!")
p("Team members generated...")

# Import Projects from Jira and seeds the DB with their values
@collected_projects = []

def collect_projects(output_array)
  i = 0
  while i < output_array["values"].length
    project_key = output_array["values"][i]["key"]
    project_name = output_array["values"][i]["name"]
    project_jira_link = output_array["values"][i]["self"]
    @collected_projects << [project_key, project_name, project_jira_link]
    i += 1
  end
end

def get_projects(start)
  url = URI.parse("https://agenceinspire.atlassian.net/rest/api/3/project/search?startAt=#{start}&maxResults=50")
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
  Project.create([{'name': project[1], 'jiraid': project[0], 'link': project[2]}])
end

p("Projects listed....")


# Collect Projects in data base
projects_array = []
Project.all.each do |project|
  projects_array << [ project[:jiraid] , project[:name] ]
end

p("Projects table generated...")

projects_array.each do |key, name|
  10.times do
    Issue.create(
      jiraid: "#{key}-#{SecureRandom.random_number(999)}",
      project: "#{name}",
      owner: Owner.all.sample.name,
      departement: Departement.all.sample.name,
      time_real: rand(1..20),
      time_forecast: rand(1..20)
    )
  end
end

p("Issues seeded!")

#Seed the user table from the team members table
#users_array = []
#User.all.each do |user|
#  users_array << [ user[:name] , user[:email] ]
#end

User.create!({:email => "admin@inspiregroup.io", :password => "azertyu", :password_confirmation => "azertyu", :admin => true})
p("User admin@inspiregroup.io created...")

User.create!({:email => "ayoub.benthabet@inspiregroup.io", :password => "azertyu", :password_confirmation => "azertyu", :admin => false})

p("User ayoub.benthabet@inspiregroup.io created...")
p("Database seeded with success!")
