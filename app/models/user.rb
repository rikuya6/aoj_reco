# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  administrator   :boolean          default(FALSE), not null
#  code            :string
#  name            :string
#  submissions     :integer          default(0), not null
#  solved          :integer          default(0), not null
#  accepted        :integer          default(0), not null
#  wronganswer     :integer          default(0), not null
#  timelimit       :integer          default(0), not null
#  memorylimit     :integer          default(0), not null
#  outputlimit     :integer          default(0), not null
#  compileerror    :integer          default(0), not null
#  runtimeerror    :integer          default(0), not null
#  last_submit_at  :datetime
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  # アクセサ


  # 関連
  has_many :user_problems, dependent: :destroy
  has_many :problems, through: :user_problems


  # フック


  # バリデーション
  validates :code,            presence: true,
                              uniqueness: { case_sensitive: true }
  validates :name,            presence: true
  validates :submissions,     presence: true
  validates :solved,          presence: true
  validates :accepted,        presence: true
  validates :wronganswer,     presence: true
  validates :timelimit,       presence: true
  validates :memorylimit,     presence: true
  validates :outputlimit,     presence: true
  validates :compileerror,    presence: true
  validates :runtimeerror,    presence: true


  # メソッド


  # プライベートメソッド
  private
end
