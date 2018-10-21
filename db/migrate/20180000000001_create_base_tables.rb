class CreateBaseTables < ActiveRecord::Migration[5.2]
  def self.up
    # ユーザ
    create_table :users do |t|
      t.string  :email,            null: false
      t.boolean :administrator,    null: false, default: false
      t.string  :password_digest,  null: false

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :users
  end
end
