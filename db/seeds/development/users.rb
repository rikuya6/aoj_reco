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

1.upto(10) do |idx|
  User.create(
    email: Faker::Internet.safe_email(Faker::Internet.user_name(Faker::StarWars.character, %w(. _ -))),
    password: 'password',
    password_confirmation: 'password'
  )
end
