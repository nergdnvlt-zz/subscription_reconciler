require 'faker'

10.times do
  sub = Sub.create!(
    xsolla_id: Faker::IDNumber.south_african_id_number,
    active: true,
    state: 'active',
    term: 'day',
    next_charge_date: "11/3/2020",
    product: 'xolla_bronze',
    product_display: 'XSolla Bronze'
  )
  puts "#{sub.id} created!"
end
