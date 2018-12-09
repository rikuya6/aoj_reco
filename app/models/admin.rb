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
