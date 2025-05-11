class CreateSessionUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :session_users do |t|
      t.references :session, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :session_users, [:session_id, :user_id], unique: true
  end
end
