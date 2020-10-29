require 'faker'

10.times do
  sub = Sub.create!(
    xsolla_id: Faker::IDNumber.south_african_id_number,
    active: true,
    state: 'active',
    term: 'monthly',
    next_charge_date: Faker::Date.forward(days: 27),
    product: 'xolla_bronze',
    product_display: 'XSolla Bronze'
  )
  puts "#{sub.id} created!"
end
