class Aoj::Problem < Aoj::Api
  include Volume

  def initialize
    @problems = {}
  end

  def get_volume_problems(volume_id)
    set_volume_problems(volume_id)
    convert_to_problem_model_attrs_hash!(volume_id)
  end

  def get_user_solved_problem_codes(volume_id)
    set_volume_problems(volume_id)
    get_solved_problem_codes_from(volume_id)
  end


  private

  def get_problems(volume_id)
    path = Rails.root.join("db/seeds/aoj/aoj_problems_#{volume_id}.json")
    if File.exist?(path)
      p path
      problems = get_problems_data_from(path)
    else
      problems = api_get("problems/volumes/#{volume_id}")['problems']
      write_problems_data_to(path, problems) if problems.present?
    end

    problems
  end

  def set_volume_problems(volume_id)
    @problems[volume_id] ||= get_problems(volume_id)
  end

  def get_problems_data_from(path)
    data = File.read(path)
    JSON.parse(data)
  end

  def write_problems_data_to(path, problems)
    File.write(path, JSON.dump(problems))
  end

  def convert_to_problem_model_attrs_hash!(volume_id)
    raise Exception, "@problems[#{volume_id}]が空です" unless @problems[volume_id].present?

    converted = []
    @problems[volume_id].each do |problem|
      converted << {
        code:          problem["id"],
        title:         problem["name"],
        time_limit:    problem["problemTimeLimit"],
        mmemory_limit: problem["problemMemoryLimit"],
        solved_user:   problem["solvedUser"],
        submissions:   problem["submissions"],
        volume:        volume_id,
        success_rate:  problem["successRate"]
      }
    end
    @problems[volume_id] = converted
  end

  def get_solved_problem_codes_from(volume_id)
    ids = []
    @problems[volume_id].each do |problem|
      ids << problem['id'] if problem['isSolved']
    end

    ids
  end
end
