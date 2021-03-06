class CreateBaseTables < ActiveRecord::Migration[5.2]
  def self.up
    # 管理者
    create_table :admins do |t|
      t.string :name,             null: false
      t.string :password_digest,  null: false
      t.timestamps null: false
    end

    # ユーザ
    create_table :users do |t|
      t.string    :code,             null: false
      t.string    :name,             null: false
      t.integer   :submissions,      null: false, default: 0
      t.integer   :solved,           null: false, default: 0
      t.integer   :accepted,         null: false, default: 0
      t.integer   :wronganswer,      null: false, default: 0
      t.integer   :timelimit,        null: false, default: 0
      t.integer   :memorylimit,      null: false, default: 0
      t.integer   :outputlimit,      null: false, default: 0
      t.integer   :compileerror,     null: false, default: 0
      t.integer   :runtimeerror,     null: false, default: 0
      t.float     :ability

      t.timestamps null: false
    end
    add_index :users, :code, unique: true

    # 問題
    create_table :problems do |t|
      t.string    :code,            null: false
      t.string    :title,           null: false
      t.string    :time_limit,      null: false
      t.string    :mmemory_limit,   null: false
      t.integer   :solved_user,     null: false
      t.integer   :submissions,     null: false
      t.string    :success_rate,    null: false
      t.string    :volume
      t.float     :difficulty

      t.timestamps null: false
    end
    add_index :problems, :code, unique: true

    create_table :user_problems do |t|
      t.references :user,        null: false
      t.references :problem,     null: false

      t.timestamps null: false
    end
    add_index :user_problems, [:user_id, :problem_id], unique: true
  end

  def self.down
    drop_table :user_problems
    drop_table :users
    drop_table :problems
    drop_table :admins
  end
end
