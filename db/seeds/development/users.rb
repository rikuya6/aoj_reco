# User.create!(
#   email: 'admin@aojreco.com',
#   code: 'aojreco_admin',
#   name: 'aojreco_admin',
#   password: 'password',
#   password_confirmation: 'password',
#   administrator: true
# )


1.upto(5) do |i|
  User.create!(
    email: "2000#{i}@aojreco.com",
    code: "2000#{i}",
    name: "2000#{i}"
  )
end
