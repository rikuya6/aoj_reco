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
#  volume        :string
#  large_cl      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Problem < ApplicationRecord
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
  # validates :volume
  # validates :large_cl


  # メソッド


  # プライベートメソッド
  private
end
