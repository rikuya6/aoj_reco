# == Schema Information
#
# Table name: user_problems
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  problem_id :integer          not null
#  solved     :boolean          default(FALSE), not null
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
