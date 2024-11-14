# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def generate_valid_isbn
  # Generate the first 12 digits randomly
  digits = Array.new(12) { rand(0..9) }

  # Calculate the sum of the first 12 digits with the ISBN-13 weighting (alternating 1 and 3)
  weighted_sum = digits.each_with_index.sum do |digit, index|
    weight = index.even? ? 1 : 3
    digit * weight
  end

  # Calculate the checksum digit (d13) such that the total sum % 10 == 0
  checksum = (10 - weighted_sum % 10) % 10

  # Append the checksum to the digits array
  digits.push(checksum)

  # Join the digits array into a 13-digit number
  digits.join.to_s
end

if Rails.env.development?
  25.times do |i|
    book = Book.new(title: Faker::Book.title, author: Faker::Book.author, publication_year: i - 2025, isbn: generate_valid_isbn )
    puts book.save!
  end
end

