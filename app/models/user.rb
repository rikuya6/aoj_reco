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
  include EmailAddressChecker

  # アクセサ
  attr_accessor :changed

  # 関連
  has_many :user_problems, dependent: :destroy
  has_many :problems, through: :user_problems


  # フック
  before_validation :check_last_submit_at
  before_save { email.downcase! }
  after_save :update_user_problems!


  # バリデーション
  validate  :check_email

  validates :email,           presence: true,
                              uniqueness: { case_sensitive: false }
  validates :submissions,     presence: true
  validates :solved,          presence: true
  validates :accepted,        presence: true
  validates :wronganswer,     presence: true
  validates :timelimit,       presence: true
  validates :memorylimit,     presence: true
  validates :outputlimit,     presence: true
  validates :compileerror,    presence: true
  validates :runtimeerror,    presence: true
  validates :password,        presence: { on: :create },
                              length: {
                                allow_blank: true,
                                minimum: 6,
                              }


  # メソッド
  has_secure_password


  # プライベートメソッド
  private

  def check_email
    if email.present?
      errors.add(:email, :invalid) unless well_formed_as_email_address(email)
    end
  end

  def check_last_submit_at
    return unless last_submit_at_was.present?
    if last_submit_at_was < last_submit_at
      self.changed = true
    end
  end

  def update_user_problems!
    return unless changed

  end
end
