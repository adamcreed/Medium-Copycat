# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
Dir["./db/scrapers/*.rb"].each { |file| require file }

# byebug
