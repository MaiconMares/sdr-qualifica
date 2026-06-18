class CreateWorkSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :work_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :started_at, null: false
      t.datetime :ended_at
      t.datetime :paused_at
      t.datetime :resumed_at
      t.integer :total_pause_duration_seconds, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.integer :effective_duration_seconds
      t.integer :net_work_duration_seconds

      t.timestamps
    end

    add_index :work_sessions, [ :user_id, :status ]
    add_index :work_sessions, :started_at
    add_index :work_sessions, :status
  end
end
