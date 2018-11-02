class Aoj::Problem < Aoj::Api
  include Volume

  def initialize
    @problems = {}
  end

  def get_volume_problems(volume_id)
    set_volume_problems(volume_id)
    convert_to_problem_model_attrs_hash!(volume_id)
  end


  private

  def get_problems(volume_id)
    api_get("problems/volumes/#{volume_id}")['problems']
  end

  def set_volume_problems(volume_id)
    @problems[volume_id] ||= get_problems(volume_id)
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
end
