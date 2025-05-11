class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.string :title
      t.text :description
      t.datetime :scheduled_at, null: false # Making scheduled_at mandatory
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end

    # Adding index for scheduled_at (for better performance when querying sessions by time)
    add_index :sessions, :scheduled_at
  end
end
