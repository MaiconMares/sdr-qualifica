class CreateCallSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :call_sessions do |t|
      t.references :lead, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :work_session, null: true, foreign_key: true
      t.datetime :started_at, null: false
      t.datetime :ended_at
      t.integer :duration_seconds
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :call_sessions, [ :lead_id, :user_id ]
    add_index :call_sessions, :started_at
    add_index :call_sessions, :status
  end
end
