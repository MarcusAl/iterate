# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

user = User.create!
user2 = User.create!

project1 = Project.create(name: 'Project Batman', description: Faker::Superhero.name, created_at: 1.month.ago)
project1.start!
project2 = Project.create(name: 'Project Superman', description: Faker::Superhero.name, created_at: 1.day.ago)
project2.start!
project2.complete!
project3 = Project.create(name: 'Project Flash', description: Faker::Superhero.name, created_at: 1.week.ago)
project3.start!
project3.cancel!

Post.create(title: Faker::Superhero.name, comment: Faker::Lorem.sentence, project_id: 1, user_id: user.id)
Post.create(title: Faker::Superhero.name, comment: Faker::Lorem.sentence, project_id: 1, user_id: user2.id)
Post.create(title: Faker::Superhero.name, comment: Faker::Lorem.sentence, project_id: 2, user_id: user2.id)
Post.create(title: Faker::Superhero.name, comment: Faker::Lorem.sentence, project_id: 2, user_id: user.id)
