# == Schema Information
#
# Table name: admins
#
#  id              :bigint(8)        not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Admin < ApplicationRecord
  # アクセサ


  # 関連


  # フック


  # バリデーション
  validates :name,            presence: true
  validates :password,        presence: { on: :create },
                              length: {
                                allow_blank: true,
                                minimum: 6,
                              }


  # メソッド
  has_secure_password


  # プライベートメソッド
  private
end
