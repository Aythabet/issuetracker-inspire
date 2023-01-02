# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Issue.destroy_all
Project.destroy_all
Owner.destroy_all
Departement.destroy_all

p("Database dropped!")

issue = Issue.create([{
    "jiraid": "LGK-12",
    "project": "Logikko",
    "owner": "Ayoub Ben Thabet",
    "departement": "Backend",
    "time_real": 7,
    "time_forecast": 10
},
{
    "jiraid": "AC-120",
    "project": "Academix",
    "owner": "Saleh Omri",
    "departement": "Frontend",
    "time_real": 2,
    "time_forecast": 4
},
{
    "jiraid": "IT-233",
    "project": "Inspire Talent",
    "owner": "Nour Borchani",
    "departement": "Backend",
    "time_real": 73,
    "time_forecast": 80
},
{
    "jiraid": "MON-1",
    "project": "Logikko Monteur",
    "owner": "Foulen Ben Foulen",
    "departement": "DevOps",
    "time_real": 3,
    "time_forecast": 3
},
{
    "jiraid": "MON-2",
    "project": "Logikko Monteur",
    "owner": "Foulen Ben Foulen",
    "departement": "Backend",
    "time_real": 3,
    "time_forecast": 3
},
{
    "jiraid": "MON-3",
    "project": "Logikko Monteur",
    "owner": "Foulen Ben Foulen",
    "departement": "Backend",
    "time_real": 33,
    "time_forecast": 24
},
{
    "jiraid": "MON-4",
    "project": "Logikko Monteur",
    "owner": "Foulen Ben Foulen",
    "departement": "Backend",
    "time_real": 6,
    "time_forecast": 7
},
{
    "jiraid": "MON-5",
    "project": "Logikko Monteur",
    "owner": "Foulen Ben Foulen",
    "departement": "Backend",
    "time_real": 8,
    "time_forecast": 10
}
]);

p("Issues seeded!")

project = Project.create([{
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
    "name": "Logikko Monteur",
    "jiraid": "MON"
}
]);

p("Projects seeded!")

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
}
]);

p("Owners seeded!")

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
}
]);

p("Departement seeded!")
p("Database seeded!")