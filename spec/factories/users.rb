FactoryBot.define do
  factory :user do
    name { Faker::Name.name_with_middle }
    cpf { Faker::IDNumber.brazilian_citizen_number }
  end
end
