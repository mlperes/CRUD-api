puts 'Criando usuários.....'
30.times do
  User.create!(
    name: Faker::Name.name_with_middle,
    cpf: Faker::IDNumber.brazilian_citizen_number
  )
end
puts 'Usuários criados com sucesso!'