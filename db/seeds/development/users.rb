1.upto(5) do |i|
  User.create!(
    code: "2000#{i}",
    name: "2000#{i}"
  )
end
