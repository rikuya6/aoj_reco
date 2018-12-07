User.create!(
  email: 'admin@aojreco.com',
  code: 'admin',
  name: 'admin',
  password: 'password',
  password_confirmation: 'password',
  administrator: true
)

User.create!(
  email: 'user1@aojreco.com',
  code: 'user1',
  name: 'user1',
  password: 'password',
  password_confirmation: 'password'
)


aoj_u = Aoj::User.new
aoj_u.get_all_users.each do |user|
  random = SecureRandom.hex
  u = User.new(user)
  u.password = random
  u.password_confirmation = random
  u.save!
end
