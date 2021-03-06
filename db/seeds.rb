# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Discount.destroy_all
Item.destroy_all
User.destroy_all
Merchant.destroy_all

megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )
megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 100 )
brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 75 )

megan_discount = megan.discounts.create(percent_off: 10, min_quantity: 10)
megan_discount_2 = megan.discounts.create(percent_off: 20, min_quantity: 20)
brian_discount = brian.discounts.create(percent_off: 30, min_quantity: 30)
brian_discount_2 = brian.discounts.create(percent_off: 40, min_quantity: 50)


admin = User.create( email: 'admin@example.com', password: 'password_admin', role: 2, name: 'Adam the Admin', address: '123 Example St', city: 'Userville', state: 'State 1', zip: '12345')
merchant = megan.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'merchant@example.com', password: 'password_merchant')
merchant2 = brian.users.create(name: 'Brian', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'merchant2@example.com', password: 'password_merchant')
user = User.create( email: 'user@example.com', password: 'password_regular', role: 0, name: 'Ulysses the User', address: '123 Example St', city: 'Userville', state: 'State 1', zip: '12345')
