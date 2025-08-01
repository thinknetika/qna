class CreateQuestionSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :question_subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.boolean :is_active, default: true, null: false

      t.timestamps
    end

    add_index :question_subscriptions, [:user_id, :question_id], unique: true
  end
end
