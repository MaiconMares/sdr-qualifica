class CreatePauses < ActiveRecord::Migration[8.1]
  def change
    create_table :pauses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :work_session, null: false, foreign_key: true
      t.integer :reason, null: false
      t.text :description
      t.datetime :started_at, null: false
      t.datetime :ended_at
      t.integer :duration_seconds

      t.timestamps
    end

    add_index :pauses, [ :user_id, :started_at ]
    add_index :pauses, :reason
  end
end
