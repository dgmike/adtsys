# encoding: UTF-8

make_names = %w(Chevrolet Citroën Fiat Ford Honda Hyundai Kia Mitsubishi Nissan Peugeot Renault Toyota Volkswagen)

make_names.each do |name|
  Make.find_or_create_by name: name
end

puts "#{make_names.size} car makes created"
