aoj_u = Aoj::User.new
number = 0
import_users = []
users_arr = []
while aoj_u.has_next_users?
  users_arr << aoj_u.get_users_by_page(number)
  number += 1
end
User.import users_arr.flatten, on_duplicate_key_ignore: true
