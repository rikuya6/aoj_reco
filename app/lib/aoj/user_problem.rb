class Aoj::UserProblem < Aoj::Api

  def initialize(user_code)
    @user_problems = {}
    @current_page = -1 # 0から始まるため
    @user_code = user_code
  end

  def get_user_problems
    number = 0
    while has_next_user_submission?
      user_problem =  get_user_submission_by_page(number)
      @user_problems[number] = user_problem if user_problem.present?
      number += 1
    end

    @user_problems.values.flatten
  end


  private

  def get_user_submission_by_page(number)
    path = Rails.root.join("db/seeds/aoj/aoj_user_problems_#{@user_code}_#{number}.json")
    submissions = nil
    if File.exist?(path)
      p path
      submissions = get_user_problems_data_from(path)
    else
      begin
        submissions = api_get("submission_records/users/#{@user_code}", { page: number })
      rescue Exception => e
        p e.message
        return nil
      end
      submission = [] if submissions.blank?
      write_user_problems_data_to(path, submissions)
    end

    return nil if submissions.blank?
    convert_to_user_problems_model_attrs_hash!(number, submissions)
  end

  def has_next_user_submission?
    return false if get_user_submission_by_page(@current_page + 1).blank?
    @current_page += 1
    true
  end

  def get_user_problems_data_from(path)
    data = File.read(path)
    JSON.parse(data)
  end

  def write_user_problems_data_to(path, user_problems)
    File.write(path, JSON.dump(user_problems))
  end

  def convert_to_user_problems_model_attrs_hash!(page, submissions)
    raise Exception, "submissionsが空です" unless submissions.present?

    converted = []
    submissions.each do |submission|
      user = ::User.find_by(code: @user_code)
      problem = ::Problem.find_by(code: submission['problemId'])
      next if problem.blank?
      next if submission['status'] != 4
      next if ::UserProblem.find_by(user_id: user.id, problem_id: problem.id).present?
      converted << {
        user_id:       user.id,
        problem_id:    problem.id,
      }
    end

    converted
  end
end
