# == Schema Information
#
# Table name: user_problems
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)        not null
#  problem_id :bigint(8)        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserProblem < ApplicationRecord
  # 関連
  belongs_to :user
  belongs_to :problem


  # バリデーション
  validates :user_id,       presence: true,
                            uniqueness: { scope: :problem_id }
  validates :problem_id,    presence: true,
                            uniqueness: { scope: :user_id }


  # メソッド


  # プライベートメソッド
  private
end
