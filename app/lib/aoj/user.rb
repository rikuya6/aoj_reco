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
        name:          user['name'],
      }
    end

    converted
  end
end
