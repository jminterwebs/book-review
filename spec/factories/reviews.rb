FactoryBot.define do
  factory :review do
    content { "Great book!" }
    rating { 5 }
    user
    book
  end
end