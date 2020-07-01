# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Admin
User.create(name: 'Admin', email: 'master@email.com', password: '123456', password_confirmation: '123456', permission: :master)

# Normal Users
User.create(name: 'Mario', email: 'mario@email.com', password: '123456', password_confirmation: '123456', permission: :normal)
User.create(name: 'Luigi', email: 'luigi@email.com', password: '123456', password_confirmation: '123456', permission: :normal)
User.create(name: 'Peach', email: 'peach@email.com', password: '123456', password_confirmation: '123456', permission: :normal)
User.create(name: 'Toad', email: 'toad@email.com', password: '123456', password_confirmation: '123456', permission: :normal)
User.create(name: 'Wario', email: 'wario@email.com', password: '123456', password_confirmation: '123456', permission: :normal)
User.create(name: 'Bowser', email: 'bowser@email.com', password: '123456', password_confirmation: '123456', permission: :normal)
