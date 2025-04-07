class CreateUserRewards < ActiveRecord::Migration[7.2]
  def change
    create_table :user_rewards do |t|
      t.references :user, null: false, foreign_key: true
      t.references :reward, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end

    add_index :user_rewards, [ :reward_id, :question_id ], unique: true  end
end
