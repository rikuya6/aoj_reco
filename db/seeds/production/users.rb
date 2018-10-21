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
