# User.create!(
#   email: 'admin@aojreco.com',
#   code: 'aojreco_admin',
#   name: 'aojreco_admin',
#   password: 'password',
#   password_confirmation: 'password',
#   administrator: true
# )

aoj_u = Aoj::User.new
number = 0
import_users = []
users_arr = []
while aoj_u.has_next_users?
  users_arr << aoj_u.get_users_by_page(number)
  number += 1
end

# random = SecureRandom.hex
# users_arr.each_with_index do |users, i|
#   p "users_#{i}"
#   import_users << users.map do |user|
#                     u = User.new(user)
#                     u.password = random
#                     u.password_confirmation = random
#                     u
#                   end
# end
User.import users_arr.flatten, on_duplicate_key_ignore: true
