# == Schema Information
#
# Table name: problems
#
#  id            :bigint(8)        not null, primary key
#  code          :string           not null
#  title         :string           not null
#  time_limit    :string           not null
#  mmemory_limit :string           not null
#  solved_user   :integer          not null
#  submissions   :integer          not null
#  success_rate  :string           not null
#  volume        :string
#  difficulty    :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Problem < ApplicationRecord

  # 定数


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


  # クラスメソッド
  def self.set_estimate_data
    @@u_count = 10
    @@u_count2 = 3000
    @@p_count = 10
    @@user_count = UserProblem.group(:user_id).having("COUNT(*) >= #{@@u_count}").count.count # 受験者数　@@TODO 受験者を誰にするか決める,
    @@problem_count = UserProblem.group(:problem_id).having("COUNT(*) >= #{@@p_count}").count.count
    @@exclusion_problem_ids = Problem.select(:id).where.not(id: UserProblem.select(:problem_id).group(:problem_id).having("COUNT(*) >= #{@@p_count}")).order(:id)
    @@problems = Problem.where.not(id: @@exclusion_problem_ids).order(:id)
    @@user_problems_select_user_id = UserProblem.select(:user_id).group(:user_id).having("COUNT(*) >= #{@@u_count} AND COUNT(*) < #{@@u_count2}").order(:user_id)
  end

  def self.estimate_prox
    set_estimate_data
    return unless @@user_count > 2
    item = calc_init_item_calibrations # 初期項目困難度
    # p '初期項目困難度', item[:init_item_calibrations]
    person = calc_init_person_measures # 初期受験者能力
    # p '初期受験者能力', person[:init_person_measures]
    item_u = calc_unbiased_variance(item[:incorrect_odds], item[:incorrect_odds_mean]) # 項目困難度の不偏分散: 応答データのばらつき度合いを求める
    # p '項目困難度の不偏分散', item_u
    person_u = calc_unbiased_variance(person[:init_person_measures], person[:init_person_measures_mean]) # 受験者能力の不偏分散
    # p '受験者能力の不偏分散', person_u
    item_finals = calc_final_calibrations(person_u, item_u, item[:init_item_calibrations])   # 最終項目困難度
    # p '最終項目困難度', item_finals
    person_finals = calc_final_calibrations(item_u, person_u, person[:init_person_measures]) # 最終受験者能力
    # p '最終受験者能力', person_finals

    # モデルの更新
    ActiveRecord::Base.transaction do
      Problem.update_all(difficulty: -999)
      User.update_all(ability: -999)
      @@problems.each do |one|
        one.difficulty = item_finals[one.id]
        one.save!
      end
      @@user_problems_select_user_id.each do |user_problem| # 「項目」となる問題を解いたユーザのみを利用する
        one = user_problem.user
        one.ability = person_finals[one.id]
        one.save!
      end
    end

    true # 正常終了
  end

  def self.calc_init_item_calibrations
    # 初期項目困難度を計算する
    # 初めに、項目困難度の線形化し誤答のログ・オッズを求める
    incorrect_odds = {} # 誤答のログ・オッズ
    @@problems.each do |problem|
      # correct_count = problem.user_problems.count
      correct_count = Problem.joins(user_problems: :user).where('user_problems.problem_id = ?', problem.id)
                             .where('user_problems.user_id IN (?)', @@user_problems_select_user_id)
                             .where('user_problems.problem_id NOT IN (?)', @@exclusion_problem_ids)
                             .count
      correct_rate = correct_count / @@user_count.to_f # 正答率
      incorrect_rate = 1 - correct_rate                # 誤答率
      incorrect_odds[problem.id] = Math.log(incorrect_rate / correct_rate)
    end
    # p incorrect_odds
    # 初期項目困難度の計算
    item = {}
    item[:incorrect_odds] = incorrect_odds
    item[:incorrect_odds_mean] = incorrect_odds.values.sum / @@problem_count # ログ・オッズの平均値
    item[:init_item_calibrations] = incorrect_odds.transform_values { |w| w - item[:incorrect_odds_mean] } # 初期項目困難度

    item
  end
  private_class_method :calc_init_item_calibrations

  def self.calc_init_person_measures
    # 正答のログ・オッズを計算する。計算結果が、初期受験者能力となる。
    correct_odds = {} # 正答のログ・オッズ
    @@user_problems_select_user_id.each do |user_problem|
      user = user_problem.user
      correct_count = user.user_problems.count
      correct_rate = correct_count / @@problem_count.to_f  # 正答率
      incorrect_rate = 1 - correct_rate                    # 誤答率
      correct_odds[user.id] = Math.log(correct_rate / incorrect_rate)
    end
    correct_odds_mean = correct_odds.values.sum / @@user_count.to_f
    # 初期受験者能力。ただし、初期項目困難度の計算時に原点を定める作業を行っている場合に限る
    { init_person_measures: correct_odds, init_person_measures_mean: correct_odds_mean }
  end
  private_class_method :calc_init_person_measures

  def self.calc_unbiased_variance(vers, mean)
    vers.transform_values { |ver| (ver - mean) ** 2 }.values.sum / (vers.size - 1) # 不偏分散
  end
  private_class_method :calc_unbiased_variance


  def self.calc_final_calibrations(u, v, init_items)
    ef = expansion_factor(u, v)
    init_items.transform_values { |item| item * ef }
  end
  private_class_method :calc_final_calibrations

  def self.expansion_factor(u, v)
    Math.sqrt((1 + u / 2.89) / (1 - u * v / 8.35)) # 2.89は1.7を2乗した値。8.35は1.7を4乗した値。
  end
  private_class_method :expansion_factor


  def self.recommend(user)
    ret = { easy: [], normal: [], hard: [] }
    return ret if user.ability == -999 # 推薦対象外
    ret = Hash.new { |h, k| h[k] = [] }

    set_estimate_data
    theta = user.ability
    @@problems.each do |problem|
      # next if problem.difficulty == -999 # 推薦対象外の問題
      next if user.user_problems.find_by(problem_id: problem.id).present? # すでに解いているためスキップ
      b = problem.difficulty
      ptheta = 1 / (1 + Math.exp(- 1.7 * (theta - b)))
      # if ptheta >= 0.9
      #   ret[:easy] << problem # if ret[:easy].size < 3
      # elsif ptheta >= 0.70
      #   ret[:normal] << problem # if ret[:normal].size < 3
      # else
      #   ret[:hard] << problem # if ret[:hard].size < 3
      # end
      # break # if ret[:easy].size == 3 && ret[:normal].size == 3 && ret[:hard].size == 3
      ret[ptheta.ceil(2)] << problem
    end
    ret.each { |_, arr| arr.sort!.reverse! }

    ret
  end


  # メソッド
  def solved?(user)
    return false unless user.present?
    UserProblem.find_by(user_id: user.id, problem_id: id)
  end


  # プライベートメソッド
  private
end
