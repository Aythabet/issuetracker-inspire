# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
require 'securerandom'
require "csv"



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

project = Project.create([
                           {
                             "name": "ValJob",
                             "jiraid": "VAL"
                           },
                           {
                             "name": "Logikko",
                             "jiraid": "LGK"
                           },
                           {
                             "name": "Academix",
                             "jiraid": "AC"
                           },
                           {
                             "name": "Inspire Talent",
                             "jiraid": "IT"
                           },
                           {
                             "name": "Peach Up",
                             "jiraid": "PU"
                           }
]);

p("Projects Randomized!")

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


User.create!({:email => "admin@inspiregroup.io", :password => "azertyu", :password_confirmation => "azertyu", :admin => true})
p("User admin@inspiregroup.io created...")

User.create!({:email => "ayoub.benthabet@inspiregroup.io", :password => "azertyu", :password_confirmation => "azertyu", :admin => false})

p("User ayoub.benthabet@inspiregroup.io created...")
p("Database seeded with success!")
