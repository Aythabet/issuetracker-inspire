# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
require 'securerandom'


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

owner = Owner.create([{
    "name": "Ayoub Ben Thabet",
    "speciality": "Backend"
},
{
    "name": "Nour Borchani",
    "speciality": "Frontend"
},
{
    "name": "Saleh Omri",
    "speciality": "Backend"
},
{
    "name": "Foulen Ben Foulen",
    "speciality": "Design"
},
{
    "name": "Mohamed Ben Mohamed",
    "speciality": "Frontend"
},
{
    "name": "Karim Mirak",
    "speciality": "DevOps"
},
{
    "name": "Clarice Lecter",
    "speciality": "Design"
},
{
    "name": "Lou Garou",
    "speciality": "Backend"
}
]);

p("Owners seeded!")

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

p("Projects seeded!")

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


p("Database seeded with success!")