class Aoj::User < Aoj::Api

  def initialize
    @current_page = -1 # 0から始まるため
  end

  def get_users_by_page(number)
    users = _get_users_by_page(number)
    return nil if users.blank?
    convert_to_user_model_attrs_hash(number, users)
  end

  def has_next_users?
    return false if get_users_by_page(@current_page + 1).blank?
    @current_page += 1
    true
  end


  private

  def _get_users_by_page(number)
    path = Rails.root.join("db/seeds/aoj/aoj_users_#{number}.json")
    users = nil
    if File.exist?(path)
      p path
      users = get_users_data_from(path)
    else
      users = api_get('users', { page: number })
      write_users_data_to(path, users) if users.present?
    end

    users
  end

  def get_users_data_from(path)
    data = File.read(path)
    JSON.parse(data)
  end

  def write_users_data_to(path, users)
    File.write(path, JSON.dump(users))
  end

  def convert_to_user_model_attrs_hash(page, users)
    raise Exception, "users[#{page}]が空です" unless users.present?

    converted = []

    users.each do |user|
      converted << {
        code:          user['id'],
        name:          user['name']
      }
      status = nil
      if user['status'].present?
        status =
          {
            submissions:   user['status']['submissions'],
            solved:        user['status']['solved'],
            accepted:      user['status']['accepted'],
            wronganswer:   user['status']['wrongAnswer'],
            timelimit:     user['status']['timeLimit'],
            memorylimit:   user['status']['memoryLimit'],
            outputlimit:   user['status']['outputLimit'],
            compileerror:  user['status']['compileError'],
            runtimeerror:  user['status']['runtimeError']
          }
      else
        status =
        {
          submissions:   0,
          solved:        0,
          accepted:      0,
          wronganswer:   0,
          timelimit:     0,
          memorylimit:   0,
          outputlimit:   0,
          compileerror:  0,
          runtimeerror:  0
        }
      end
      converted.last.merge! status
    end

    converted
  end
end
