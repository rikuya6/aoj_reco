aoj_p = Aoj::Problem.new
vlist = aoj_p.get_volume_list
vlist.each do |volume_id|
  problems = aoj_p.get_volume_problems(volume_id)
  problems.each do |problem|
    Problem.create!(problem)
  end
  break # @TODO 暫定 開発中のみ
end
