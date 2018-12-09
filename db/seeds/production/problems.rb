aoj_p = Aoj::Problem.new
vlist = aoj_p.get_volume_list
vlist.each do |volume_id|
  problems = aoj_p.get_volume_problems(volume_id)
  problems.each do |problem|
    one = Problem.new(problem)
    one.difficulty = 100 - one.success_rate.to_f
    one.save!
  end
end
