User.create!(
  email: 'admin@aojreco.com',
  password: 'password',
  password_confirmation: 'password',
  administrator: true
)

User.create!(
  email: 'user1@aojreco.com',
  password: 'password',
  password_confirmation: 'password'
)

names = []
3.times do
  names <<  Faker::Internet.user_name(Faker::StarWars.character, %w(. _ -))
end

names.each do |name|
  User.create!(
    email: Faker::Internet.safe_email(name),
    password: 'password',
    password_confirmation: 'password'
  )
end
