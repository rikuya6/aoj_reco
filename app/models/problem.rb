# == Schema Information
#
# Table name: problems
#
#  id            :integer          not null, primary key
#  code          :string           not null
#  title         :string           not null
#  time_limit    :string           not null
#  mmemory_limit :string           not null
#  solved_user   :integer          not null
#  submissions   :integer          not null
#  success_rate  :string           not null
#  volume        :string
#  large_cl      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Problem < ApplicationRecord

  # 定数
  MAX_DIFFICULTY = 100.0


  # 関連
  has_many :user_problems, dependent: :destroy
  has_many :users, through: :user_problems


  # バリデーション
  validates :code,              presence: true,
                                uniqueness: { case_sensitive: false }
  validates :title,             presence: true,
                                length: {
                                  allow_blank: true,
                                  maximum: 255,
                                }
  validates :time_limit,        presence: true
  validates :mmemory_limit,     presence: true
  validates :solved_user,       presence: true
  validates :submissions,       presence: true
  validates :success_rate,      presence: true
  # validates :volume
  # validates :large_cl


  # クラスメソッド
  def self.recommend(user)
    user_problem = user.user_problems.joins(:problem).order('problems.difficulty DESC').first
    return nil unless user_problem.present?
    problem = user_problem.problem
    theta = -3
    max_theta = -3

    b = problem.difficulty / MAX_DIFFICULTY
    60.times do
      theta *= 10
      theta += 1
      theta /= 10.0
      ptheta = 1 / (1 + Math.exp(- 1.7 * (theta - b)))
      p "シータ:" + theta.to_s + "　確率：" + ptheta.to_s
      if ptheta >= 0.7
        p theta
        max_theta = theta
        break
      end
    end

    ret = { easy: [], normal: [], hard: [] }
    Problem.all.each do |problem|
      next if user.user_problems.find_by(problem_id: problem.id).present?
      # next if problem.difficulty.to_i < 1
      b = problem.difficulty.to_f / MAX_DIFFICULTY
      ptheta = 1 / (1 + Math.exp(- 1.7 * (max_theta - b)))

      if ptheta >= 0.9
        ret[:easy] << problem if ret[:easy].size < 3
      elsif ptheta >= 0.75
        ret[:normal] << problem if ret[:normal].size < 3
      else
        ret[:hard] << problem if ret[:hard].size < 3
      end
      break if ret[:easy].size == 3 && ret[:normal].size == 3 && ret[:hard].size == 3
    end
    p max_theta

    ret
  end


  # メソッド
  def solved?(user)
    return false unless user.present?
    UserProblem.find_by(user_id: user.id, problem_id: id).try!(:solved)
  end


  # プライベートメソッド
  private
end
