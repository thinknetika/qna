class CreateVotes < ActiveRecord::Migration[7.2]
  def change
    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :votable, polymorphic: true, null: false
      t.integer :value

      t.timestamps
    end

    add_index :votes, [ :user_id, :votable_id, :votable_type ], unique: true
  end
end
