User.find_in_batches do |users|
  import_user_problems = []
  users.each do |user|
    user_problems = Aoj::UserProblem.new(user.code).get_user_problems
    user_problems.uniq!
    import_user_problems << user_problems
  end
  UserProblem.import import_user_problems.flatten
end
