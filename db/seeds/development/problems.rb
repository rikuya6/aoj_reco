1.upto(4) do |i|
  Problem.create!(
    code: i,
    title: i,
    time_limit: i,
    mmemory_limit: i,
    solved_user: i,
    submissions: i,
    success_rate: i,
    volume: i,
    difficulty: i
  )
end
